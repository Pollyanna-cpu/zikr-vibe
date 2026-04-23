# User Stories: Zikr Vibe App MVP (P0)

**Date**: 2026-04-02 (canonical) — updated 2026-04-24 for companionship/privacy pivot
**Sprint scope**: 6 weeks → App Store + Play Store submission
**Format**: User Story + Acceptance Criteria + Effort estimate

**Canonical reference**: See `Zikr-Vibe-App-PRD.md` for full P0-P2 definitions and rationale.

---

## Epic 1: Dhikr Counter (Week 1)

### US-1.1: Tap-to-Count
**As a** Muslim doing dhikr,
**I want to** tap the screen to count each repetition,
**so that** I don't lose count.

**Acceptance Criteria:**
- [ ] Full-screen tap zone (lower 80% of screen = tappable)
- [ ] Count increments by 1 per tap
- [ ] **Light haptic on each tap + strong distinct vibration at 33/66/99 milestones** (eyes-closed tasbih, user research: "I want to close my eyes and feel the count")
- [ ] 33-bead progress visualization (circular dots showing position in current round)
- [ ] Count displayed prominently (large font, center screen)
- [ ] Works in portrait mode only (one-hand use)
- [ ] Counter persists if app is backgrounded mid-session, force-quit, or battery death (Hive local storage, write-on-every-tap)
- [ ] **Long-press to reset** with bottom-sheet confirmation (matches user review: "when I have to clean the dhikr I have to tap THREE TIMES, drives me nuts")
- [ ] Distraction-free: no notification overlays, minimal UI chrome during active counting

**Effort**: 1 day (haptic milestone + 33-bead visualization adds complexity)

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

### US-1.4: Local Persistence (Privacy-First)
**As a** user,
**I want** my dhikr counts saved permanently on my device,
**so that** I never lose my progress AND my dhikr data never leaves my phone.

**Acceptance Criteria:**
- [ ] Session auto-saves to local Hive storage on each count (write-on-every-tap, ACID-safe)
- [ ] Session record: dhikr type, count, start time, end time, date — **stored locally only**
- [ ] **Dhikr data never syncs to any server** (privacy promise — see PRD §9)
- [ ] Only circle presence (boolean "did dhikr today") syncs, never counts
- [ ] Counts survive force quit, restart, backgrounding, battery death
- [ ] No "save" button needed — everything is automatic

**Effort**: 1 day

---

### US-1.5: Zero Ads Enforcement (Architectural Guarantee)
**As a** user,
**I want** to never see ads in Zikr Vibe — not even during Ramadan, not even for "halal" products,
**so that** my worship is not interrupted.

**Acceptance Criteria:**
- [ ] No ad SDK in `pubspec.yaml` (not AdMob, not Facebook Audience Network, not anything)
- [ ] No ad-ready code paths, no "if (adsEnabled)" conditionals anywhere
- [ ] CI lint rule (optional but recommended): fail build if any ad-related dependency added
- [ ] App Store / Play Store listing explicitly: "No ads. No data selling."

**Effort**: 0 days (enforcement by exclusion — verify in code review)

---

### US-1.6: Zero Data Collection on Prayer Content
**As a** user,
**I want** my dhikr type, count, and frequency never tracked or analyzed,
**so that** my worship data cannot be sold, leaked, or breached.

**Acceptance Criteria:**
- [ ] No Firebase Analytics SDK in dependencies (remove entirely)
- [ ] No custom analytics on dhikr content
- [ ] Crashlytics opt-in only, with explicit consent dialog at first launch
- [ ] Privacy policy explicitly lists: what we collect (email + display name for circles only), what we don't (dhikr content, location, IP)
- [ ] Supabase database schema: no `count` column on any server-side table (architectural guarantee)

**Effort**: 0.5 day (consent dialog + schema audit)

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

## Epic 3: Companion Circles (Week 3) — NOT Ranking

**Design rationale**: Research invalidated the ranking thesis. Devout Muslims consider sharing dhikr counts as riya' (showing off). Circles show **presence, not volume**. See PRD §8 (Companion Circles Redesigned).

### US-3.1: Create Circle
**As a** user,
**I want to** create a private dhikr circle for family or close friends,
**so that** we can support each other's practice without competing.

**Acceptance Criteria:**
- [ ] Circle name (required, 3-30 chars)
- [ ] Circle description (optional, 100 chars max)
- [ ] Creator becomes admin
- [ ] **Max 10 members per circle** (intimate, not broadcast)
- [ ] User can be in up to 5 circles
- [ ] Circle gets a unique invite code

**Effort**: 1 day

---

### US-3.2: Invite to Circle
**As a** circle admin or member,
**I want to** invite friends via WhatsApp link,
**so that** they join my circle.

**Acceptance Criteria:**
- [ ] "Invite" button generates shareable link
- [ ] Pre-written WhatsApp message (companionship framing, NOT competition):
  - EN: *"Join my dhikr circle on Zikr Vibe — let's remember Allah together. [link]"*
  - AR: *"انضم إلى دائرة الذكر الخاصة بي — لنذكر الله معًا"*
- [ ] Share sheet supports: WhatsApp, SMS, Copy Link, other apps
- [ ] Link uses `app_links` (Universal Links / App Links) — **NOT Firebase Dynamic Links** (deprecated)
- [ ] Self-hosted redirect: `https://zikrvibe.com/join/CIRCLE_CODE`
- [ ] New user: link → App Store/Play Store → install → auto-join circle (deferred deep link)
- [ ] Existing user: link → opens app → auto-join circle
- [ ] Invite link expires after 7 days (regeneratable)

**Effort**: 2 days (deep linking is complex)

---

### US-3.3: Companionship Board (NOT Leaderboard)
**As a** circle member,
**I want to** see who did their dhikr today — not how much, just presence,
**so that** I feel accompanied without being judged or comparing.

**Acceptance Criteria:**
- [ ] Board shows each member's name + binary status:
  - ✓ if they did dhikr today
  - · with "last active: yesterday / 3 days ago" otherwise
- [ ] **NO counts displayed anywhere** (no numbers, no ranks, no "total dhikr this week")
- [ ] **NO ranking or sorting by activity** (alphabetical or join-order only)
- [ ] Only your OWN streak shown privately (never others' streaks)
- [ ] Summary: "X of Y members remembered Allah today" (aggregate presence, not individual counts)
- [ ] Weekly view: calendar grid showing who was active which days (✓/· only)
- [ ] Updates within 5 minutes of a member's first dhikr of the day
- [ ] Design rationale prominent in onboarding: "Ibadah is between you and Allah"

**Effort**: 1.5 days

---

### US-3.4: Join Circle
**As an** invited user,
**I want to** join a circle from an invite link,
**so that** I can be present with my family/friends.

**Acceptance Criteria:**
- [ ] Clicking invite link while app installed → app opens → "Join [Circle Name]?" confirmation → joined
- [ ] Clicking invite link without app → App Store/Play Store → install → onboarding → auto-join
- [ ] Onboarding landing page (web): shows circle name + member count + "Your data stays on your device" (privacy framing)
- [ ] User appears on board immediately after joining
- [ ] User can leave circle anytime (settings within circle screen)

**Effort**: 1 day (depends on deep link work in US-3.2)

---

### US-3.5: Circle List
**As a** user in multiple circles,
**I want to** see all my circles in one place,
**so that** I can switch between them.

**Acceptance Criteria:**
- [ ] Circle tab (🤝) shows list of joined circles
- [ ] Each circle card: name, member count, "X of Y present today" (aggregate only, no individual stats)
- [ ] "Create Circle" button at top
- [ ] "Join Circle" (enter code) option
- [ ] "Join an Open Circle" option for users without friends on app (solves empty-room problem — Pre-Mortem T4)
- [ ] Tap circle → goes to Companionship Board

**Effort**: 0.5 day

---

### US-3.6: Gentle Nudge (Optional)
**As a** circle member,
**I want to** send a "thinking of you" tap to a member who hasn't checked in today,
**so that** I can gently encourage without policing.

**Acceptance Criteria:**
- [ ] Available only if member hasn't checked in by evening (local time)
- [ ] One-tap sends a content-free nudge (no message, just presence)
- [ ] Max 1 nudge per member per day
- [ ] Recipient sees: "[Name] is thinking of you" (no judgment, no "you haven't done your dhikr")
- [ ] Opt-out in settings

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

### US-5.1: Sign Up / Sign In (Optional — app works without login)
**As a** new user,
**I want to** use the app immediately without signing up,
**so that** I can start counting without committing to an account.

**Acceptance Criteria:**
- [ ] **"Skip — Count without account" option prominent on login screen**
- [ ] Sign in with Apple (required for iOS App Store if offering auth at all)
- [ ] Sign in with Google
- [ ] Sign in with email + password (fallback)
- [ ] Set display name during onboarding (only if signing up — required for circles)
- [ ] Optional avatar (photo or default icon)
- [ ] Account → Supabase Auth
- [ ] If user skips login: all dhikr data stored locally, circles feature disabled
- [ ] User can sign up later to unlock circles without losing local data

**Effort**: 1 day

---

### US-5.2: Onboarding Flow (Three Promises)
**As a** new user,
**I want** a brief, privacy-first introduction,
**so that** I understand what Zikr Vibe does and doesn't do before granting permissions.

**Acceptance Criteria:**
- [ ] 3 screens max, reflecting the Three Promises (PRD §10):
  - **Screen 1**: *"Your dhikr is private."* No data collection. No cloud. Local-first.
  - **Screen 2**: *"Your worship is sacred."* No ads. No scores. No judgment.
  - **Screen 3**: *"Your tool is reliable."* Count persists. Works offline. Doesn't break.
- [ ] Skip button on every screen
- [ ] **Permission requests AT LAST screen, with clear rationale** (not before trust is established):
  - Notification permission → "For prayer time reminders. Off by default."
  - Location permission → "For prayer times + Qibla. Never sent to our servers."
- [ ] If user arrived via circle invite: show "Join [Name]'s dhikr circle?" after onboarding
- [ ] Goes directly to dhikr counter after onboarding
- [ ] Onboarding works without login (show "skip login" option after Screen 3)

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
| 1 | Dhikr Counter (E1: includes Zero Ads + Zero Data + local persistence) + Auth (E5) | 6 days |
| 2 | Streak & History (E2) + Auth finish | 4 days |
| 3 | Companion Circles (E3: presence not ranking) | 6.5 days |
| 4 | Prayer Times & Qibla (E4) | 3.5 days |
| 5 | Polish & UI Theme (E6) | 3 days |
| 6 | Testing, Bug Fixes, Submission | 3 days |
| **Total** | | **26 dev days** |

Fits within 6 weeks with small buffer for unexpected issues. Circle Loop deep linking (US-3.2) is the highest-risk item — see Pre-Mortem T1.

---

*Each story is small enough to ship in a day. Each epic is testable independently.*
