-- Fix: Create Circle must use the same SECURITY DEFINER boundary as Join Circle.
--
-- Fresh OAuth smoke test on 2026-05-08 showed direct client INSERT into
-- `groups` still fails RLS with 42501, even after a valid PKCE token exchange.
-- Keep the RLS policy as-is, but move circle creation into an authenticated RPC
-- that inserts `groups` and `memberships` atomically as the function definer.

CREATE OR REPLACE FUNCTION public.create_circle(p_name TEXT)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
  v_group_id UUID;
  v_invite_code TEXT;
  v_name TEXT;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  v_name := trim(p_name);
  IF char_length(v_name) < 3 OR char_length(v_name) > 30 THEN
    RAISE EXCEPTION 'Circle name must be 3 to 30 characters';
  END IF;

  LOOP
    v_invite_code := upper(substr(replace(gen_random_uuid()::TEXT, '-', ''), 1, 8));

    BEGIN
      INSERT INTO groups (name, admin_id, invite_code, member_count)
      VALUES (v_name, v_user_id, v_invite_code, 1)
      RETURNING id INTO v_group_id;
      EXIT;
    EXCEPTION WHEN unique_violation THEN
      -- Extremely unlikely, but invite_code is unique. Retry through the loop.
    END;
  END LOOP;

  INSERT INTO memberships (group_id, user_id)
  VALUES (v_group_id, v_user_id)
  ON CONFLICT DO NOTHING;

  RETURN v_invite_code;
END;
$$;

REVOKE ALL ON FUNCTION public.create_circle(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.create_circle(TEXT) TO authenticated;
