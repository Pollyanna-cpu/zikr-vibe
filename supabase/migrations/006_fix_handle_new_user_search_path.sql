-- Fix: handle_new_user trigger function had mutable search_path which is a
-- security risk for SECURITY DEFINER functions (search-path hijack vector).
-- Also added qualified table names (public.users / public.streaks /
-- public.notification_prefs) so the function works regardless of caller's
-- search_path setting.
--
-- Background: 001_initial_schema.sql defined handle_new_user without
-- `SET search_path` and without schema-qualified table names. When a new
-- auth user signs up, the AFTER INSERT trigger on auth.users runs this
-- function as the table owner (postgres). Without a fixed search_path the
-- function's INSERT INTO users could resolve to a different schema if the
-- caller's search_path is manipulated. This migration locks search_path to
-- 'public', 'auth', 'pg_temp' and qualifies all table names.
--
-- This migration was originally applied to remote project ocxnevqgjiyhwdfpskfc
-- 2026-05-06 via Supabase Dashboard SQL Editor (registered in
-- supabase_migrations.schema_migrations as version "20260506200546" with
-- name "fix_handle_new_user_search_path", created_by soulvibeai@gmail.com).
-- The corresponding migration file was not committed to the working tree
-- at the time. This file is a retroactive write of the same SQL, captured
-- by CC MCP cleanup 2026-05-09 from pg_get_functiondef of the live function.
-- File registered in schema_migrations as version "006" alongside the
-- original timestamp row.

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public', 'auth', 'pg_temp'
AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name, auth_provider)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_app_meta_data->>'provider', 'email')
  )
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.streaks (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  INSERT INTO public.notification_prefs (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$;
