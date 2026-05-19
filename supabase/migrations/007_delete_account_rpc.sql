-- Adds user-initiated account deletion for Play Console Data Safety
-- compliance + fixes invites.used_by FK to allow deletion of users who
-- previously redeemed an invite link.
--
-- Without this migration:
--   - `public.users` has no DELETE RLS policy and no client-callable RPC,
--     so the "Settings → Delete Account" flow promised in the privacy
--     policy and Data Safety form has no implementation
--   - `invites.used_by` defaults to NO ACTION on delete, which blocks
--     `DELETE FROM users WHERE id = uid` when the user ever joined a
--     Circle via an invite link (FK violation)
--
-- After this migration:
--   - `public.delete_account()` removes the caller's `public.users` row,
--     which cascades to `daily_presence`, `streaks`, `memberships`, and
--     `notification_prefs` (cascade declared in 001_initial_schema.sql)
--   - `groups.admin_id`, `invites.invited_by`, and `invites.used_by`
--     are SET NULL on user delete, preserving Circle continuity and
--     invite history without holding a dangling FK
--
-- Limitation: this RPC removes data from the `public` schema only.
-- Supabase does not expose `auth.users` self-deletion via SDK — that row
-- remains and the email cannot be reused for signup until the user
-- emails soulvibeai@gmail.com for full removal. The data safety form
-- and privacy policy claim only `public` data is removed, which is
-- what this RPC delivers.

BEGIN;

-- Fix invites.used_by cascade (default NO ACTION blocks user delete)
ALTER TABLE invites DROP CONSTRAINT IF EXISTS invites_used_by_fkey;
ALTER TABLE invites
  ADD CONSTRAINT invites_used_by_fkey
  FOREIGN KEY (used_by) REFERENCES users(id) ON DELETE SET NULL;

CREATE OR REPLACE FUNCTION public.delete_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  uid uuid := auth.uid();
BEGIN
  IF uid IS NULL THEN
    RAISE EXCEPTION 'Authentication required' USING ERRCODE = 'P0001';
  END IF;

  DELETE FROM public.users WHERE id = uid;
END;
$$;

REVOKE ALL ON FUNCTION public.delete_account() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.delete_account() TO authenticated;

COMMIT;
