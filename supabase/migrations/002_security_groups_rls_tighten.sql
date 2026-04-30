-- Tighten groups SELECT RLS
-- Before: any authenticated user can dump all groups (invite_codes leaked)
-- After: only group members can SELECT; invite-code lookup via SECURITY DEFINER RPC
--
-- Membership table in this schema is `memberships` (see 001_initial_schema.sql).
-- The RPC inserts a row into memberships and returns the group UUID.

DROP POLICY IF EXISTS "Anyone can read group by invite code" ON groups;

-- Members-only SELECT already exists in 001 ("Members can read their groups");
-- 001 also adds an `Anyone can read group by invite code` policy that we drop above.
-- Re-create the members-only policy idempotently in case 001 ran without the
-- members policy line for any reason.
DROP POLICY IF EXISTS "Members can read their groups" ON groups;
CREATE POLICY "Members can read their groups" ON groups
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM memberships
      WHERE memberships.group_id = groups.id
        AND memberships.user_id = auth.uid()
    )
  );

-- RPC for invite-code lookup + auto-join (atomic, runs as definer to bypass RLS)
CREATE OR REPLACE FUNCTION public.join_group_by_invite_code(code TEXT)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_group_id UUID;
  v_user_id UUID;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  SELECT id INTO v_group_id
  FROM groups
  WHERE invite_code = upper(trim(code))
  LIMIT 1;

  IF v_group_id IS NULL THEN
    RAISE EXCEPTION 'Invalid invite code';
  END IF;

  INSERT INTO memberships (group_id, user_id)
  VALUES (v_group_id, v_user_id)
  ON CONFLICT DO NOTHING;

  RETURN v_group_id;
END;
$$;

REVOKE ALL ON FUNCTION public.join_group_by_invite_code(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.join_group_by_invite_code(TEXT) TO authenticated;
