-- Zikr Vibe App — Simplified Schema (Privacy-First)
-- Philosophy: Server only stores PRESENCE (✓/·), never dhikr content or counts.
-- All dhikr data stays on-device (Hive).

-- ============================================
-- USERS
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  auth_provider TEXT DEFAULT 'email',
  timezone TEXT DEFAULT 'Asia/Dubai',
  prayer_method TEXT DEFAULT 'UmmAlQura',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- DAILY PRESENCE (replaces dhikr_sessions)
-- Only stores: "this user was active on this date"
-- No dhikr type, no count, no target — that's private
-- ============================================
CREATE TABLE IF NOT EXISTS daily_presence (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (user_id, date)
);

CREATE INDEX idx_presence_date ON daily_presence(date);

-- ============================================
-- STREAKS (calculated from daily_presence)
-- ============================================
CREATE TABLE IF NOT EXISTS streaks (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_active_date DATE,
  mercy_days_used INTEGER DEFAULT 0,
  mercy_week_start DATE
);

-- ============================================
-- GROUPS
-- ============================================
CREATE TABLE IF NOT EXISTS groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL CHECK (char_length(name) BETWEEN 3 AND 30),
  description TEXT CHECK (char_length(description) <= 100),
  admin_id UUID REFERENCES users(id) ON DELETE SET NULL,
  invite_code TEXT UNIQUE NOT NULL,
  member_count INTEGER DEFAULT 1,
  -- Shared Streak (Duolingo model): one person breaks, all reset
  shared_streak INTEGER DEFAULT 0,
  longest_shared_streak INTEGER DEFAULT 0,
  shared_streak_last_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_groups_invite_code ON groups(invite_code);

-- ============================================
-- GROUP MEMBERSHIPS
-- ============================================
CREATE TABLE IF NOT EXISTS memberships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(group_id, user_id)
);

CREATE INDEX idx_memberships_user ON memberships(user_id);
CREATE INDEX idx_memberships_group ON memberships(group_id);

-- ============================================
-- INVITES
-- ============================================
CREATE TABLE IF NOT EXISTS invites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  invited_by UUID REFERENCES users(id) ON DELETE SET NULL,
  invite_link TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- NOTIFICATION PREFERENCES
-- ============================================
CREATE TABLE IF NOT EXISTS notification_prefs (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  fajr_enabled BOOLEAN DEFAULT FALSE,
  dhuhr_enabled BOOLEAN DEFAULT FALSE,
  asr_enabled BOOLEAN DEFAULT FALSE,
  maghrib_enabled BOOLEAN DEFAULT FALSE,
  isha_enabled BOOLEAN DEFAULT FALSE,
  offset_minutes INTEGER DEFAULT 10
);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_presence ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE invites ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_prefs ENABLE ROW LEVEL SECURITY;

-- Users: own profile + group co-members' basic info
CREATE POLICY "Users can read own profile"
  ON users FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON users FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Group members can see co-members"
  ON users FOR SELECT
  USING (
    id IN (
      SELECT m2.user_id FROM memberships m1
      JOIN memberships m2 ON m1.group_id = m2.group_id
      WHERE m1.user_id = auth.uid()
    )
  );

-- Daily presence: own data + group co-members can see (just ✓/·)
CREATE POLICY "Users can CRUD own presence"
  ON daily_presence FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Group members can see co-member presence"
  ON daily_presence FOR SELECT
  USING (
    user_id IN (
      SELECT m2.user_id FROM memberships m1
      JOIN memberships m2 ON m1.group_id = m2.group_id
      WHERE m1.user_id = auth.uid()
    )
  );

-- Streaks: own + group co-members
CREATE POLICY "Users can read own streak"
  ON streaks FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own streak"
  ON streaks FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Group members can see co-member streaks"
  ON streaks FOR SELECT
  USING (
    user_id IN (
      SELECT m2.user_id FROM memberships m1
      JOIN memberships m2 ON m1.group_id = m2.group_id
      WHERE m1.user_id = auth.uid()
    )
  );

-- Groups
CREATE POLICY "Members can read their groups"
  ON groups FOR SELECT
  USING (id IN (SELECT group_id FROM memberships WHERE user_id = auth.uid()));

CREATE POLICY "Anyone can read group by invite code"
  ON groups FOR SELECT USING (true);

CREATE POLICY "Authenticated users can create groups"
  ON groups FOR INSERT WITH CHECK (auth.uid() = admin_id);

-- Memberships
CREATE POLICY "Users can see memberships in their groups"
  ON memberships FOR SELECT
  USING (group_id IN (SELECT group_id FROM memberships WHERE user_id = auth.uid()));

CREATE POLICY "Users can join groups"
  ON memberships FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can leave groups"
  ON memberships FOR DELETE USING (auth.uid() = user_id);

-- Invites
CREATE POLICY "Users can read invites for their groups"
  ON invites FOR SELECT
  USING (group_id IN (SELECT group_id FROM memberships WHERE user_id = auth.uid()));

CREATE POLICY "Group members can create invites"
  ON invites FOR INSERT
  WITH CHECK (
    invited_by = auth.uid()
    AND group_id IN (SELECT group_id FROM memberships WHERE user_id = auth.uid())
  );

-- Notification prefs: own data only
CREATE POLICY "Users can CRUD own notification prefs"
  ON notification_prefs FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Auto-create user profile + streak row on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO users (id, email, display_name, auth_provider)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_app_meta_data->>'provider', 'email')
  )
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO streaks (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  INSERT INTO notification_prefs (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Update streak when presence is recorded
CREATE OR REPLACE FUNCTION update_streak_on_presence()
RETURNS TRIGGER AS $$
DECLARE
  last_date DATE;
  curr_streak INTEGER;
  max_streak INTEGER;
BEGIN
  SELECT last_active_date, current_streak, longest_streak
  INTO last_date, curr_streak, max_streak
  FROM streaks WHERE user_id = NEW.user_id;

  IF last_date IS NULL OR NEW.date > last_date THEN
    IF last_date = NEW.date - 1 THEN
      curr_streak := COALESCE(curr_streak, 0) + 1;
    ELSIF last_date = NEW.date - 2 THEN
      curr_streak := COALESCE(curr_streak, 0) + 1;
    ELSE
      curr_streak := 1;
    END IF;

    IF curr_streak > COALESCE(max_streak, 0) THEN
      max_streak := curr_streak;
    END IF;

    UPDATE streaks SET
      current_streak = curr_streak,
      longest_streak = max_streak,
      last_active_date = NEW.date
    WHERE user_id = NEW.user_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_presence_recorded
  AFTER INSERT ON daily_presence
  FOR EACH ROW EXECUTE FUNCTION update_streak_on_presence();

-- Update group member count on membership change
CREATE OR REPLACE FUNCTION update_group_member_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE groups SET member_count = member_count + 1 WHERE id = NEW.group_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE groups SET member_count = member_count - 1 WHERE id = OLD.group_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_membership_change
  AFTER INSERT OR DELETE ON memberships
  FOR EACH ROW EXECUTE FUNCTION update_group_member_count();
