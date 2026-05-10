-- Fix: member_count should be derived from memberships, not incremented from
-- a seeded value. The v1.0.12 create_circle RPC inserted groups.member_count=1,
-- then the memberships INSERT trigger incremented it to 2 for a one-person
-- circle.

CREATE OR REPLACE FUNCTION public.update_group_member_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_group_id UUID;
BEGIN
  v_group_id := COALESCE(NEW.group_id, OLD.group_id);

  UPDATE groups
  SET member_count = (
    SELECT COUNT(*)::INTEGER
    FROM memberships
    WHERE memberships.group_id = v_group_id
  )
  WHERE id = v_group_id;

  RETURN COALESCE(NEW, OLD);
END;
$$;

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
      INSERT INTO groups (name, admin_id, invite_code)
      VALUES (v_name, v_user_id, v_invite_code)
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

UPDATE groups
SET member_count = counts.member_count
FROM (
  SELECT groups.id, COUNT(memberships.user_id)::INTEGER AS member_count
  FROM groups
  LEFT JOIN memberships ON memberships.group_id = groups.id
  GROUP BY groups.id
) AS counts
WHERE groups.id = counts.id;
