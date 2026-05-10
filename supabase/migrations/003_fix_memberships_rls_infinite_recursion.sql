-- Fix: PostgrestException 42P17 infinite recursion in policy for "memberships".
--
-- Root cause: every policy that gates row visibility by group co-membership
-- runs `SELECT ... FROM memberships WHERE ...` inside its USING clause. That
-- inner SELECT re-triggers memberships RLS, which evaluates the same policy,
-- which runs the same SELECT, etc. Postgres detects the loop (42P17) and
-- aborts. Symptom: Groups tab dies with the error in app UI.
--
-- Fix: two SECURITY DEFINER helpers that bypass RLS internally and return
-- (a) the caller's group_ids and (b) the caller's co-member user_ids. RLS
-- policies use these helpers so the inner SELECT never re-enters the table
-- under RLS evaluation. Same logical intent, no recursion.
--
-- Applied to remote project ocxnevqgjiyhwdfpskfc 2026-05-07 via Supabase MCP.

CREATE OR REPLACE FUNCTION public.current_user_group_ids()
RETURNS SETOF uuid
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT group_id FROM memberships WHERE user_id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.current_user_co_member_ids()
RETURNS SETOF uuid
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT DISTINCT m2.user_id
  FROM memberships m1
  JOIN memberships m2 ON m1.group_id = m2.group_id
  WHERE m1.user_id = auth.uid();
$$;

REVOKE ALL ON FUNCTION public.current_user_group_ids() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.current_user_co_member_ids() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.current_user_group_ids() TO authenticated;
GRANT EXECUTE ON FUNCTION public.current_user_co_member_ids() TO authenticated;

-- ---------------- memberships (self-recursive, the actual 42P17 trigger) ----------------
DROP POLICY IF EXISTS "Users can see memberships in their groups" ON memberships;
CREATE POLICY "Users can see memberships in their groups"
  ON memberships FOR SELECT
  USING (
    user_id = auth.uid()
    OR group_id IN (SELECT public.current_user_group_ids())
  );

-- ---------------- groups (EXISTS subquery on memberships) ----------------
DROP POLICY IF EXISTS "Members can read their groups" ON groups;
CREATE POLICY "Members can read their groups"
  ON groups FOR SELECT
  USING (id IN (SELECT public.current_user_group_ids()));

-- ---------------- invites ----------------
DROP POLICY IF EXISTS "Users can read invites for their groups" ON invites;
CREATE POLICY "Users can read invites for their groups"
  ON invites FOR SELECT
  USING (group_id IN (SELECT public.current_user_group_ids()));

DROP POLICY IF EXISTS "Group members can create invites" ON invites;
CREATE POLICY "Group members can create invites"
  ON invites FOR INSERT
  WITH CHECK (
    invited_by = auth.uid()
    AND group_id IN (SELECT public.current_user_group_ids())
  );

-- ---------------- users (co-member visibility) ----------------
DROP POLICY IF EXISTS "Group members can see co-members" ON users;
CREATE POLICY "Group members can see co-members"
  ON users FOR SELECT
  USING (id IN (SELECT public.current_user_co_member_ids()));

-- ---------------- daily_presence (co-member visibility) ----------------
DROP POLICY IF EXISTS "Group members can see co-member presence" ON daily_presence;
CREATE POLICY "Group members can see co-member presence"
  ON daily_presence FOR SELECT
  USING (user_id IN (SELECT public.current_user_co_member_ids()));

-- ---------------- streaks (co-member visibility) ----------------
DROP POLICY IF EXISTS "Group members can see co-member streaks" ON streaks;
CREATE POLICY "Group members can see co-member streaks"
  ON streaks FOR SELECT
  USING (user_id IN (SELECT public.current_user_co_member_ids()));
