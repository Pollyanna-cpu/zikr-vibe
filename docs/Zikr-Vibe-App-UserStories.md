# User Stories: Zikr Vibe App MVP (P0)

**Date**: 2026-04-02
**Sprint scope**: 6 weeks → App Store + Play Store submission
**Format**: User Story + Acceptance Criteria + Effort estimate

---

## Epic 1: Dhikr Counter (Week 1)

### US-1.1: Tap-to-Count
**As a** Muslim doing dhikr,
**I want to** tap the screen to count each repetition,
**so that** I don't lose count.

**Acceptance Criteria:**
- [ ] Full-screen tap zone (lower 70% of screen = tappable)
- [ ] Count increments by 1 per tap
- [ ] Haptic feedback on each tap (short vibration)
- [ ] Count displayed prominently (large font, center screen)
- [ ] Works in portrait mode only (one-hand use)
- [ ] Counter persists if app is backgrounded mid-session
- [ ] Reset button with "Are you sure?" confirmation

**Effort**: 0.5 day

---

### US-1.2: Preset Targets
**As a** user,
**I want to** select a target number (33, 66, 99, 100, custom),
**so that** I know when I've completed my set.

**Acceptance Criteria:**
- [ ] 4 preset buttons: 33, 66, 99, 100
- [ ] Custom input field for any number
- [ ] Progress ring/bar shows progress toward target
- [ ] Distinct haptic + visual celebration when target reached
- [ ] Option: auto-reset after target hit (toggle in settings)
- [ ] Option: continue counting past target

**Effort**: 0.5 day

---

### US-1.3: Multiple Dhikr Types
**As a** user,
**I want to** switch between dhikr types,
**so that** I can track different prayers separately.

**Acceptance Criteria:**
- [ ] 4 pre-loaded dhikr: SubhanAllah (سبحان الله), Alhamdulillah (الحمد لله), Allahu Akbar (الله أكبر), La ilaha illallah (لا إله إلا الله)
- [ ] Each shows Arabic text + transliteration
- [ ] Custom dhikr: user enters name + optional target
- [ ] Each type has independent count for current session
- [ ] Quick-switch: swipe left/right or tap dhikr selector
- [ ] Last-used dhikr is default when app opens

**Effort**: 1 day

---

### US-1.4: Session Save
**As a** user,
**I want** my dhikr sessions saved automatically,
**so that** I never lose my progress.

**Acceptance Criteria:**
- [ ] Session auto-saves to local storage on each count
- [ ] Session syncs to Supabase when network available
- [ ] Session record: dhikr type, count, start time, end time, date
- [ ] If offline, queues syncs and pushes when reconnected
- [ ] No "save" button needed — everything is automatic

**Effort**: 1 day

---

## Epic 2: Streak & History (Week 2)

### US-2.1: Daily Dhikr Log
**As a** user,
**I want to** see my dhikr history by day,
**so that** I can track my consistency.

**Acceptance Criteria:**
- [ ] Calendar view: green dot = dhikr day, empty = missed
- [ ] Tap any day to see: total count, breakdown by dhikr type, number of sessions
- [ ] Weekly summary bar chart (Mon-Sun)
- [ ] Monthly total displayed

**Effort**: 1.5 days

---

### US-2.2: Streak Tracking
**As a** user,
**I want to** see my current streak (consecutive dhikr days),
**so that** I stay motivated.

**Acceptance Criteria:**
- [ ] Current streak count on home screen (prominent)
- [ ] Longest-ever streak displayed in profile
- [ ] Streak resets at midnight local time if no dhikr recorded
- [ ] "Mercy day": 1 free streak freeze per week (auto-applied on first miss)
- [ ] Mercy day indicator: "Streak saved by mercy day (1/1 used this week)"
- [ ] Milestone badges: 7, 30, 100, 365 days

**Effort**: 1 day

---

### US-2.3: Profile Screen
**As a** user,
**I want** a profile showing my lifetime stats,
**so that** I can see my overall progress.

**Acceptance Criteria:**
- [ ] Display name + avatar (optional photo or default icon)
- [ ] Lifetime total dhikr count
- [ ] Current streak + longest streak
- [ ] Groups list (with links)
- [ ] Member since date
- [ ] Settings gear icon → Settings screen

**Effort**: 0.5 day

---

## Epic 3: Groups & Ranking (Week 3)

### US-3.1: Create Group
**As a** user,
**I want to** create a dhikr group,
**so that** I can track with friends.

**Acceptance Criteria:**
- [ ] Group name (required, 3-30 chars)
- [ ] Group description (optional, 100 chars max)
- [ ] Creator becomes admin
- [ ] Max 50 members per group (v1.0)
- [ ] User can be in up to 5 groups
- [ ] Group gets a unique invite code

**Effort**: 1 day

---

### US-3.2: Invite to Group
**As a** group admin or member,
**I want to** invite friends via WhatsApp/SMS link,
**so that** they join my circle.

**Acceptance Criteria:**
- [ ] "Invite" button generates shareable link
- [ ] Pre-written WhatsApp message: "Join my dhikr circle '[Group Name]' on Zikr Vibe — let's see who's most consistent! [link]"
- [ ] Share sheet supports: WhatsApp, SMS, Copy Link, other apps
- [ ] Link uses Firebase Dynamic Links (deferred deep linking)
- [ ] New user: link → App Store/Play Store → install → auto-join group
- [ ] Existing user: link → opens app → auto-join group
- [ ] Invite link expires after 7 days (regeneratable)

**Effort**: 2 days (deep linking is complex)

---

### US-3.3: Group Leaderboard
**As a** group member,
**I want to** see who's most consistent this week/month,
**so that** I stay accountable.

**Acceptance Criteria:**
- [ ] Leaderboard sorted by consistency score: (days active ÷ total days in period) × 100%
- [ ] Toggle: This Week / This Month
- [ ] Each row shows: rank, name, avatar, consistency %, current streak, total dhikr this period
- [ ] Current user's row highlighted
- [ ] Updates within 5 minutes of new dhikr session
- [ ] Group total dhikr displayed at top

**Effort**: 1.5 days

---

### US-3.4: Join Group
**As an** invited user,
**I want to** join a group from an invite link,
**so that** I can see the leaderboard and participate.

**Acceptance Criteria:**
- [ ] Clicking invite link while app installed → app opens → "Join [Group Name]?" confirmation → joined
- [ ] Clicking invite link without app → App Store/Play Store → install → onboarding → auto-join
- [ ] User appears on leaderboard immediately after joining
- [ ] User can leave group anytime (settings within group screen)

**Effort**: 1 day (depends on deep link work in US-3.2)

---

### US-3.5: Group List
**As a** user in multiple groups,
**I want to** see all my groups in one place,
**so that** I can switch between them.

**Acceptance Criteria:**
- [ ] Groups tab shows list of joined groups
- [ ] Each group card: name, member count, my rank this week
- [ ] "Create Group" button at top
- [ ] "Join Group" (enter code) option
- [ ] Tap group → goes to group leaderboard

**Effort**: 0.5 day

---

## Epic 4: Prayer Times & Qibla (Week 4)

### US-4.1: Prayer Times Display
**As a** Muslim,
**I want to** see today's 5 prayer times for my location,
**so that** I pray on time.

**Acceptance Criteria:**
- [ ] Auto-detect location (GPS with permission)
- [ ] Display: Fajr, Dhuhr, Asr, Maghrib, Isha with times
- [ ] Next prayer highlighted with countdown
- [ ] Calculation method selector: Umm al-Qura (default KSA), Dubai, ISNA, Muslim World League, Egyptian, Karachi
- [ ] Manual location override option
- [ ] Times update when location changes

**Effort**: 1 day (using adhan library)

---

### US-4.2: Prayer Notifications
**As a** user,
**I want** push notifications before each prayer,
**so that** I don't miss.

**Acceptance Criteria:**
- [ ] Notifications OFF by default (opt-in during onboarding)
- [ ] Per-prayer toggle (enable/disable each of 5 prayers individually)
- [ ] Configurable offset: 0, 5, 10, 15, 30 minutes before
- [ ] Notification shows: prayer name + time + "Time for [Prayer]"
- [ ] Tap notification → opens app to dhikr counter
- [ ] Respects device Do Not Disturb
- [ ] Background location updates to keep times accurate

**Effort**: 1.5 days

---

### US-4.3: Qibla Compass
**As a** user,
**I want to** see the direction of Mecca,
**so that** I face the right way during prayer.

**Acceptance Criteria:**
- [ ] Uses device compass + GPS
- [ ] Arrow/indicator pointing toward Kaaba
- [ ] Distance to Mecca displayed
- [ ] Compass accuracy indicator (calibration prompt if needed)
- [ ] Works without internet (compass is local)

**Effort**: 1 day

---

## Epic 5: Auth & Onboarding (Week 1-2)

### US-5.1: Sign Up / Sign In
**As a** new user,
**I want to** create an account quickly,
**so that** my data is saved and synced.

**Acceptance Criteria:**
- [ ] Sign in with Apple (required for iOS)
- [ ] Sign in with Google
- [ ] Sign in with email + password (fallback)
- [ ] Set display name during onboarding
- [ ] Optional avatar (photo or default icon)
- [ ] Account → Supabase Auth

**Effort**: 1 day

---

### US-5.2: Onboarding Flow
**As a** new user,
**I want** a brief introduction,
**so that** I understand the app quickly.

**Acceptance Criteria:**
- [ ] 3 screens max: (1) "Count your dhikr" (2) "Track your streak" (3) "Compete with friends"
- [ ] Skip button on every screen
- [ ] Request notification permission (prayer reminders)
- [ ] Request location permission (prayer times + Qibla)
- [ ] If user arrived via group invite: show "Join [Name]'s group?" after onboarding
- [ ] Goes directly to dhikr counter after onboarding

**Effort**: 0.5 day

---

## Epic 6: Polish & Submission (Week 5-6)

### US-6.1: Islamic UI Theme
**As a** Muslim user,
**I want** the app to feel respectful and beautiful,
**so that** it feels appropriate for spiritual practice.

**Acceptance Criteria:**
- [ ] Color palette: deep emerald (#0D5C3F), warm gold (#C9A84C), cream (#FFF8F0), charcoal (#1A1A2E)
- [ ] Islamic geometric pattern accents (subtle, not overwhelming)
- [ ] Arabic calligraphy in header elements
- [ ] Fonts: clean sans-serif for UI, Amiri or similar for Arabic text
- [ ] Dark mode support (dark green/black base)
- [ ] No haram imagery, no music by default

**Effort**: 2 days

---

### US-6.2: App Store Submission
**As** the product team,
**we want** to submit to both App Store and Play Store,
**so that** users can download.

**Acceptance Criteria:**
- [ ] App Store: screenshots (6.7" and 5.5"), app icon, description (EN + AR), keywords, privacy policy URL, review notes explaining prayer notifications
- [ ] Play Store: screenshots, feature graphic, description (EN + AR), privacy policy, content rating questionnaire
- [ ] App icon: Zikr Vibe logo on emerald/gold background
- [ ] Category: Lifestyle (or Reference for Islamic content)
- [ ] Age rating: 4+ (App Store), Everyone (Play Store)

**Effort**: 1 day

---

## Sprint Summary

| Week | Epics | Total Effort |
|------|-------|-------------|
| 1 | Dhikr Counter (E1) + Auth (E5) | 5 days |
| 2 | Streak & History (E2) + Auth finish | 4 days |
| 3 | Groups & Ranking (E3) | 6 days |
| 4 | Prayer Times & Qibla (E4) | 3.5 days |
| 5 | Polish & UI Theme (E6) | 3 days |
| 6 | Testing, Bug Fixes, Submission | 3 days |
| **Total** | | **24.5 dev days** |

Fits within 6 weeks with buffer for unexpected issues.

---

*Each story is small enough to ship in a day. Each epic is testable independently.*
