# Product Requirements Document: Zikr Vibe App

**Author**: Yun / Soul Vibe Technology
**Date**: 2026-04-02 (canonical) — merged 2026-04-24
**Status**: Canonical (supersedes PRD-v2)
**Stakeholders**: Yun (CEO), Claude (Dev)
**Tagline**: *"Count your dhikr. Nothing else watches."*

---

## 1. Executive Summary

Zikr Vibe is a **free mobile app** for Islamic dhikr (remembrance of Allah) — **distraction-free, private, and consistent**. No hardware required. Tap the screen to count, feel the vibration at 33/66/99, see your streak. No ads. No data selling. No judgment. The only dhikr app built around **privacy and companionship** rather than competition.

**Why now**: Every major Muslim app has betrayed its users. Muslim Pro (170M+ downloads, 2.9★ Trustpilot) shows haram ads and sold user location data to US military contractors. Tasbeeh counter apps are ugly solo tools riddled with haram ads even after paying. iQibla Life requires a $39+ ring with terrible Bluetooth reliability and battery-death data loss. **The bar is on the floor. We pick it up by doing the one thing nobody does: respect the user.**

**One-line positioning**: *"Count your dhikr. Nothing else watches."*
**Subline**: *No ads. No data selling. No broken hardware. Just you and your remembrance.*

---

## 2. Background & Context

### The Problem

Practicing Muslims do dhikr (tasbih) daily — repeating sacred phrases (SubhanAllah, Alhamdulillah, Allahu Akbar) in sets of 33, 66, 99, or 100. Currently:

| Solution | Tracking | Privacy | Cost | Fatal Flaw |
|----------|----------|---------|------|------------|
| Physical tasbih beads | None | Perfect | $2-10 | No tracking, easy to lose count |
| Muslim Pro (2.9★ Trustpilot) | Prayer times only | **Sold data to US military** | Free/sub | Haram ads (gambling, semi-nude), subscription trap, data scandal |
| iQibla Life (3.5★ Google Play) | Ring-dependent | OK | $39+ hardware | BLE disconnect, battery death = data loss, "designed by some kid" |
| Tasbeeh Counter Pro (4.7★) | Basic counter | Ads | Free | Haram ads even after paying, off-by-one counting bug, no calendar |
| Pillars (4.8★) | Prayer tracker | Good | Free | Crashes, white screen, freezes after marking 5 prayers |

**The gap**: No app combines **distraction-free dhikr counting + haptic milestones + privacy-first design + gentle companionship** without requiring hardware or showing ads.

### Market Context

- 1.8B Muslims globally, ~1.2B with smartphones
- Islamic app market: Muslim Pro (100M+), Athan (50M+), Quran apps (200M+ combined)
- "Tasbeeh counter" and "dhikr counter" have consistent search volume year-round, with massive Ramadan spike (MENA installs +28%, UAE +126%, Saudi +67%)
- Top tasbih counter app on Google Play: 9.1M installs — demand is proven
- Muslim Pro data scandal (2020, sold location data to US military via X-Mode) created lasting trust gap — privacy-first positioning has real pull
- Pillars app grew to ~1M users on zero budget, purely through Muslim Twitter community and build-in-public approach
- Zero-to-one opportunity: no dominant player that combines quality dhikr counting + privacy + companionship

### Strategic Context

Zikr Vibe App is a **pivot from hardware-first to software-first**:
- Original plan: sell smart prayer rings ($29-59) → Ring becomes optional accessory
- App becomes the primary product: **zero COGS, infinite margin, frictionless acquisition**
- Hardware rings connect later (if/when SDK available) as premium accessory
- Aligns with Soul Vibe brand philosophy: sensor not brain, present data, never judge

---

## 3. What Changed (Research Findings, 2026-04-02)

Two rounds of user research against the initial PRD produced the following delta:

### Validated assumptions
- Distraction-free counting is the #1 pain → our core feature
- Ad-free is not a feature, it's table stakes → users feel **violated** by haram ads during dhikr
- iQibla proved demand exists but failed on quality → market is pre-educated
- Simplicity wins → Pillars (4.8★) is praised BECAUSE it's minimal

### Invalidated assumptions
- ~~Group ranking drives viral growth~~ → **Wrong.** Devout Muslims consider sharing dhikr counts as riya' (showing off). The most religious users — our core ICP — would actively avoid a leaderboard. "Ibadah is between you and Allah, not you and a leaderboard."
- ~~Social sharing is a growth engine~~ → **Partially wrong.** Milestone sharing cards might work for younger/casual users, but core users won't share counts publicly. Share streak days (binary consistency), never counts (volume).

### New insights
- **Privacy is a weapon**, not just a feature. Muslim Pro's data scandal still echoes. "Your dhikr is between you and Allah, not you and a data broker" is a killer positioning line.
- **33-count vibration** is the single most requested smart feature across all dhikr app reviews. It maps directly to the physical rhythm of tasbih beads.
- **Group companionship** (who showed up today?) is valued. **Group competition** (who did more?) is not.

---

## 4. Objectives & Success Metrics

### Goals

1. **Ship MVP to App Store + Google Play in 6 weeks**
2. **Acquire 10,000 users in first 90 days** (organic + lightweight paid)
3. **Prove companionship groups drive retention** — users in groups retain 2x better than solo users
4. **Establish Zikr Vibe as the #1 privacy-first dhikr app** — own the trust gap Muslim Pro left behind
5. **Hit Pillars-level rating (4.8★+) by being respectful** — quality signal in the Muslim community

### Non-Goals (v1.0)

| Non-Goal | Why |
|----------|-----|
| Monetization | Acquire first, monetize later. Free removes all friction |
| Quran reading | 100+ apps already do this well. Not our fight |
| Full prayer tracking (rakat counting) | Scope creep. Dhikr counting is the wedge |
| Hardware integration | No SDK available. App must work 100% standalone |
| AI religious insights | User research: Muslim community deeply skeptical of AI interpreting religion. Muslim Pro tried, users said "hire artists not AI" |
| Social leaderboards / public ranking | **Research finding**: devout Muslims actively avoid sharing dhikr counts — ibadah is between you and Allah, public sharing is considered riya' (showing off). Group feature = companionship, not competition |
| Period tracking | Too niche, not a dhikr counter's job |
| Arabic-only UI | Start with English (Gulf HNW speak English). Add Arabic in v1.1 |
| Subscription model | Users traumatized by Muslim Pro subscription traps |

### Success Metrics

| Metric | Target (30 days) | Target (90 days) | Measurement |
|--------|-----------------|-----------------|-------------|
| Downloads | 2,000 | 10,000 | App Store Connect + Google Play Console |
| DAU / MAU ratio | 35% | 45% | Firebase Analytics |
| Companionship groups created | 200 | 1,500 | Backend |
| Avg group size | 3 | 5 | Backend |
| Invites sent per group creator | 4 | 6 | Backend |
| Invite → Install conversion | 15% | 25% | Deep link tracking |
| 7-day retention | 40% | 50% | Firebase |
| 30-day retention | 20% | 30% | Firebase |
| Users in groups vs solo | 40% | 60% | Backend |
| Daily check-in rate (group members) | 50% | 70% | Backend |
| App Store rating | 4.7+ | 4.8+ | App Store / Play Store |

### Kill Criteria

- DAU/MAU < 15% after 60 days → Core engagement loop is broken
- Group users don't retain better than solo → Companionship thesis is wrong, pivot
- < 500 downloads after 30 days with marketing effort → Market doesn't exist
- App Store rating < 4.0 after 50 reviews → Stop marketing, fix issues

---

## 5. Target Users & Segments

### Primary: Gulf Practicing Muslim Men (UAE/KSA)

| Attribute | Detail |
|-----------|--------|
| Age | 25-45 |
| Location | UAE, KSA, Qatar |
| Faith practice | Prays 5x daily, does dhikr regularly |
| Tech behavior | iPhone or Android, uses WhatsApp daily, has Muslim Pro installed |
| Motivation | Wants to be more consistent in dhikr, wants gentle community accountability |
| Current solution | Physical beads + maybe a basic counter app |
| Language | English (primary), Arabic (secondary) |

### Secondary: Global Practicing Muslims

| Segment | Priority | Notes |
|---------|----------|-------|
| SEA Muslims (Malaysia, Indonesia) | v1.1 | Bahasa localization needed |
| Western diaspora (US, UK, Canada) | v1.0 | English works |
| Women | v1.0 | Same features, may need gender-separated groups option |
| Youth (18-24) | v1.0 | Most likely to adopt milestone sharing (days, not counts) |
| Ramadan-focused | Seasonal | Casual users who engage during Ramadan only |

### User Archetypes

**1. Ahmad the Consistent** — 35, Dubai, prays 5x daily, wants to track his dhikr streak and stay accountable. Currently uses physical beads. Would love to see his 365-day progress.

**2. Omar the Companion** — 28, Riyadh, has a mosque study group of 8 friends. Wants to gently keep each other accountable: "Did everyone do their dhikr today?" Not who did more — just who showed up. Currently uses a WhatsApp group to check in manually.

**3. Fatima the Returner** — 32, London, trying to rebuild her prayer practice after years away. Wants a gentle, non-judgmental tool that shows progress without shame. Doesn't want an app that scores or grades her.

**4. Yusuf the Gifter** — 40, Jeddah, wants to invite his teenage son to a family dhikr group for Ramadan. Needs the app to be simple enough for a 15-year-old.

---

## 6. User Stories & Requirements

### P0 — Must Have (MVP, ship in 6 weeks)

| # | User Story | Acceptance Criteria |
|---|-----------|-------------------|
| P0-1 | **Dhikr Counter**: As a Muslim, I want to tap the screen to count my dhikr so I don't lose count without getting distracted by my phone | - Full-screen tap zone (large, easy to hit) - Light haptic per tap + **strong distinct vibration at 33/66/99 milestones** (eyes-closed tasbih — user research: "I want to close my eyes and just feel the count") - Count displayed prominently - 33-bead progress visualization (circular dots showing position in current round) - Long-press to reset with bottom sheet confirmation - Supports portrait mode (one-hand use) - **Distraction-free**: minimal UI chrome during active counting, no notifications overlay |
| P0-2 | **Preset Targets**: As a user, I want to select dhikr presets (33, 66, 99, 100) so I complete my sets accurately | - 4 preset buttons + custom number input up to 9999 - Vibration alert when target reached - Auto-reset option after target hit - Shows progress ring/bar toward target |
| P0-3 | **Multiple Dhikr Types (3-5 counter groups)**: As a user, I want to switch between dhikr types (SubhanAllah, Alhamdulillah, Allahu Akbar, La ilaha illallah, custom) | - Pre-loaded 4 core dhikr types with Arabic text + transliteration - Custom dhikr: user enters text + optional target - Each type tracks count independently, persists across restart - Swipe horizontally to switch active counter group |
| P0-4 | **Data Persistence**: As a user, my counts must NEVER be lost unexpectedly | - Counts survive force quit, restart, backgrounding, battery death - Local Hive storage (no cloud required) - Key research signal: iQibla's #2 complaint was "battery dies, count lost" |
| P0-5 | **Daily Dhikr Log**: As a user, I want my daily dhikr counts saved automatically so I can see my history | - Auto-save every session to local (cloud opt-in only) - Daily total across all dhikr types - Calendar view showing dhikr days (green) vs missed days - Weekly/monthly summary |
| P0-6 | **Streak Tracking with Mercy Day**: As a user, I want to see my current streak so I stay motivated — without Duolingo-style guilt | - Current streak count displayed on home screen - Longest streak record - Streak milestones: 7, 30, 100, 365 days - **1 mercy day per week** (free freeze; missing one day doesn't break streak) - Streak resets if no dhikr + mercy day burned, by midnight local time |
| P0-7 | **Zero Ads (Forever)**: As a user, I must never see ads inside Zikr Vibe — not even "halal" ads | - No ad SDK included in dependencies - No ad framework, not even ad-ready code paths - Research signal: "half-naked women during dhikr" is the nuclear pain point across all competitors |
| P0-8 | **Zero Data Collection (by default)**: As a user, my dhikr must never be tracked, sold, or shared | - No analytics SDK on prayer content - No tracking of dhikr types/counts to any server - Optional anonymous crash reporting only (Crashlytics with explicit consent at first launch) - Research signal: Muslim Pro sold location data to US military — this scandal still haunts the market |
| P0-9 | **Create Companion Circle**: As a user, I want to create a private dhikr circle with friends/family | - Create circle with name + optional description - Creator is admin, max **10 members per circle** (intimate, not broadcast) - User can be in up to 5 circles - See Section 8 for full circle design |
| P0-10 | **Invite to Circle**: As a user, I want to invite friends via WhatsApp/SMS link so they join my circle | - Generate shareable invite link - Pre-written WhatsApp message: "Join my dhikr circle on Zikr Vibe — [link]" - Link opens app (if installed) or App Store/Play Store (if not) - Invited user auto-joins circle on first login |
| P0-11 | **Companionship Board (not Leaderboard)**: As a circle member, I want to see who did dhikr today — not how much, just presence | - Binary check-in: ✓ (did dhikr today) or "last active: yesterday/3 days ago" — **no counts, no ranking, no competition** - Only your OWN streak shown privately (never others') - Gentle nudge: if a member hasn't done dhikr by evening, option to send a private "thinking of you" tap - Weekly view: calendar grid showing who was active which days - **Design rationale**: ibadah is between you and Allah. Public counting is riya'. Companionship = "I know you're on this path too", not "I did more than you" |
| P0-12 | **Prayer Times**: As a Muslim, I want to see today's 5 prayer times based on my location | - Auto-detect location (GPS, opt-in) - Show Fajr, Dhuhr, Asr, Maghrib, Isha times - Calculation method selector (Umm al-Qura, ISNA, Muslim World League, etc.) - Next prayer countdown |
| P0-13 | **Prayer Notifications**: As a user, I want push notifications before each prayer so I don't miss | - **OFF by default** (opt-in only) - Configurable: X minutes before each prayer - Per-prayer toggle (enable/disable individually) - Notification sound options (clean adhan clip or silent — never haram interruption) - Respects Do Not Disturb |
| P0-14 | **Auth + Profile (optional)**: As a user, I want to sign up and sync across devices — but the app must also work without an account | - Sign up with Apple / Google / Email (optional; skip allowed) - App fully usable offline without login - If logged in: display name + optional avatar, circles sync via backend - If not logged in: all data stays on device |
| P0-15 | **Qibla Compass**: As a user, I want to see the direction of Mecca from my current location | - Uses device compass + GPS - Arrow pointing to Kaaba - Distance to Mecca displayed - Accuracy indicator + calibration prompt |

### P1 — Should Have (v1.1, weeks 7-10)

| # | User Story | Acceptance Criteria |
|---|-----------|-------------------|
| P1-1 | **Streak Milestone Cards**: As a user, I want to share my streak (not count) as a beautiful card on WhatsApp/IG | - Auto-generated card at streak milestones (7/30/100/365 consecutive days) - **Shows streak days only, NOT dhikr counts** (respects riya' concern) - Message: "I remembered Allah for 30 days straight" not "I did 99,000 dhikr" - Islamic geometric design aesthetic - One-tap share to WhatsApp/IG Stories - Subtle Zikr Vibe branding + download CTA |
| P1-2 | **Circle Invitation Cards**: As a circle creator, I want a beautiful invite card to bring friends into my dhikr circle | - "Join our dhikr circle on Zikr Vibe" - Shows circle name + member count - Does NOT show any individual stats - Pre-written WhatsApp message with deep link |
| P1-3 | **Arabic UI**: As an Arabic-speaking user, I want the app in Arabic with RTL layout | - Full Arabic translation - RTL layout support - Arabic numerals option - Auto-detect system language (en/ar) |
| P1-4 | **Invite Landing Page**: As an invited user, I want to see what this dhikr circle is about before downloading | - Web page showing circle name + member count + "X members remembered Allah today" - Privacy-first messaging: "Your data stays on your device" - "Download to Join" CTA with App Store / Play Store links - Deep link passes circle invite code through install |
| P1-5 | **Dhikr Audio**: As a user, I want optional audio for each dhikr type so I can follow along | - Audio pronunciation for each preset dhikr - Play/pause control - Auto-advance option (plays next dhikr after target hit) |
| P1-6 | **Dark Mode**: As a user, I want a beautiful dark mode — competitor complaint was "night mode didn't work properly" | - Proper OLED black option - Preserves gold accents - Auto-switch with system |
| P1-7 | **Ramadan Mode**: As a user, I want a special Ramadan experience with daily goals and Taraweeh tracking | - Ramadan calendar with daily dhikr goals - Taraweeh prayer tracker - Ramadan-specific milestone cards - Auto-activates during Ramadan dates |

### P2 — Nice to Have / Future (v2.0+)

| # | User Story | Acceptance Criteria |
|---|-----------|-------------------|
| P2-1 | **Hardware Ring Integration** | Connect Zikr Vibe ring (if SDK becomes available) for automatic dhikr counting |
| P2-2 | **Premium Tier** | **Ad-free stays free forever.** Premium = custom themes (skins), advanced calendar, cloud backup. $1.99/mo or $14.99/yr. Never a paywall on core functionality |
| P2-3 | **Imam/Leader Mode** | Circle admin can set weekly dhikr goals, send encouragement messages (not shaming), pin announcements |
| P2-4 | **Apple Watch / Wear OS** | Complication for quick dhikr counting (real user request) |
| P2-5 | **Gentle Nudge Notifications** | "You haven't opened Zikr Vibe today" — but ONLY if user opts in, and max 1 per day |
| P2-6 | **Offline Mode (full)** | All features work offline, syncs when reconnected |
| P2-7 | **Family Groups** | Parent-child circles with simplified UI for kids |
| P2-8 | **Mosque Directory** | Find nearby mosques (opt-in location) |
| P2-9 | **Dhikr Insights** | Weekly summary: "You remembered Allah 5 of 7 days this week" (presence framing, never volume scoring) |

### Explicitly NOT Doing (ever)

| Feature | Why not |
|---------|---------|
| **Leaderboards / rankings** | Riya' (showing off) — core users would leave |
| **Public count sharing** | Ibadah is private. Only binary days/streaks can be shared |
| **AI dhikr insights / interpretation** | Muslim community rejects AI in religion |
| **In-app purchases on core counter** | Feels extractive in a worship context — skins only, never counting limits |
| **Subscription paywall on counting** | Users traumatized by Muslim Pro traps — core stays free forever |
| **Any form of advertising** | The #1 reason every competitor gets 1-star reviews |
| **Streak-shame mechanics** | No aggressive loss-aversion notifications. Duolingo guilt has no place in worship |

---

## 7. Solution Overview

### Architecture

```
┌─────────────────────────────────────┐
│          MOBILE APP                  │
│           (Flutter)                  │
│                                      │
│  ┌──────────┐  ┌──────────────────┐ │
│  │  Dhikr   │  │  Companionship   │ │
│  │  Counter  │  │  Circles (✓/✗)   │ │
│  └──────────┘  └──────────────────┘ │
│  ┌──────────┐  ┌──────────────────┐ │
│  │  Prayer  │  │  Streak Tracker  │ │
│  │  Times   │  │  + Mercy Day     │ │
│  └──────────┘  └──────────────────┘ │
│  ┌──────────┐  ┌──────────────────┐ │
│  │  Qibla   │  │  Profile +       │ │
│  │  Compass  │  │  Optional Auth   │ │
│  └──────────┘  └──────────────────┘ │
└──────────────────┬──────────────────┘
                   │ API (circles only)
┌──────────────────▼──────────────────┐
│           BACKEND                    │
│         (Supabase — minimal)         │
│                                      │
│  Auth (Apple/Google/Email, optional) │
│  PostgreSQL: circles, members,       │
│    daily_presence (no counts!)       │
│  Realtime (presence sync only)       │
│  Edge Functions (invite links)       │
│                                      │
│  NO dhikr data ever touches server   │
└──────────────────────────────────────┘
```

### Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Framework | **Flutter** | Single codebase for iOS + Android. Faster than React Native for UI-heavy apps. Claude can generate Dart |
| Backend | **Supabase** (minimal) | Auth, DB, Realtime, Edge Functions. **Only for circles (presence), never for dhikr counts** |
| Local storage | **Hive** | Crash-safe, offline-first, counts persist across battery death |
| Prayer time calc | **adhan_dart** (open source) | Offline, 12 calculation methods, Qibla bearing included |
| Qibla | **flutter_qiblah** + device compass + GPS | Standard sensor APIs |
| Deep linking | **app_links** (Universal Links / App Links) | Firebase Dynamic Links deprecated; self-hosted zikrvibe.com/join/CODE |
| Push notifications | **flutter_local_notifications** for prayer times (server-free); FCM only if needed for circles | Local-first, no server dependency for core notifications |
| Haptics | Built-in `HapticFeedback` + `haptic_feedback` package | Light per tap, heavy at 33/66/99 |

### App Navigation (4 tabs)

```
┌─────────────────────────────────────┐
│                                      │
│           [MAIN SCREEN]              │
│                                      │
│    ┌────────────────────────┐        │
│    │                        │        │
│    │    DHIKR COUNTER       │        │
│    │    (full-screen tap)   │        │
│    │                        │        │
│    │        1,699           │        │
│    │    ━━━━━━━━━━━━━━      │        │
│    │    SubhanAllah          │        │
│    │    Target: 99 ▼        │        │
│    │                        │        │
│    └────────────────────────┘        │
│                                      │
│   🔥 14-day streak                   │
│   ○○○○○○●○○○○○○○○○○○○○○○○○○○○○○○○○○ │
│   (33-bead progress: 7 of 33)        │
│                                      │
├──────┬──────┬──────┬────────────────┤
│ 📿   │ 🤝   │ 🕌   │ 👤             │
│Dhikr │Circle│Prayer│Profile         │
└──────┴──────┴──────┴────────────────┘
```

### Design Principles

1. **Islamic aesthetic, not tech aesthetic** — Geometric patterns, calligraphy accents, warm gold/emerald palette. Not Material Design blue.
2. **One-hand operation** — Counter must work with single thumb taps while walking, sitting, lying down
3. **No judgment** — Show data, never score. "You counted 45 today" not "You only did 45, try harder"
4. **Respect prayer** — No intrusive UI during active dhikr. Minimal chrome, maximum counting space
5. **WhatsApp-native sharing** — Every shareable action optimized for WhatsApp (Gulf primary messaging app)
6. **Zero ads, forever** — Research: haram ads during dhikr is the #1 reason for 1-star reviews across all competitors. This is non-negotiable.
7. **Privacy by default** — All dhikr data stored locally (Hive). Cloud sync is opt-in for circles only. No analytics on prayer content. No third-party data sharing. Period.
8. **Companionship over competition** — Group features show presence (✓ did dhikr today), never volume. Ibadah is between you and Allah.

---

## 8. Companion Circles: Redesigned

### Old Design (v1 — invalidated by research)
- Group leaderboard ranked by consistency
- Public count comparison
- Competition-driven ("who's most consistent?")
- Viral loop thesis: invite → compete → invite more

### New Design (research-informed)

**Concept: "Dhikr Circle" — silent companionship, not competition**

**What you see:**
```
┌──────────────────────────┐
│  Family Circle            │
│  ─────────────────────── │
│  Ahmad      ✓ today      │
│  Khalid     ✓ today      │
│  Fatima     · yesterday   │
│  Yusuf      ✓ today      │
│  ─────────────────────── │
│  3 of 4 remembered today │
└──────────────────────────┘
```

**What you DON'T see:**
- How many each person counted (private — always)
- Rankings or comparisons
- Streaks of other people (your own streak is private)
- Any judgmental framing

**Rules:**
- Max 10 members per circle (intimate, not broadcast)
- Only shows: name + "did dhikr today" (✓) or "last active: yesterday / 3 days ago"
- No numbers, no counts, no streaks of others — only your own
- Circle creator can send one gentle text reminder per day (manual, not automated)
- Leave anytime, no friction

**Why this works:**
1. **Accountability without shame** — you know your family is praying, they know you are. Nobody's graded.
2. **The "empty chair" effect** — seeing "Fatima: yesterday" is a gentle nudge, not a judgment. She might open the app because she wants to show up, not because she's ranked last.
3. **Still viral, but slower** — "Join our family's dhikr circle" is a more natural invite than "Compete with me on dhikr." Lower K-factor, but higher quality users who retain.
4. **Respects riya' concern** — no count sharing, no public performance.

### Precedents validating this approach
- **Duolingo Friend Streak** — binary "did your friend study today?" drives **+22% daily completion** on retained users. No count comparison, just presence.
- **Cohorty** — "quiet accountability, support without noise, presence without pressure"
- **I Am Sober** — peer matching by milestone, not ranking; non-judgmental reset on relapse
- **BeReal** — pure binary "did you post today?" drove 53M downloads (cautionary tail: binary without deeper value struggles long-term — our deeper value is spiritual meaning)

---

## 9. Privacy Architecture

Privacy is a core differentiator, not an afterthought.

### What we collect

- **Device-local only**: counter data, circle presence (✓/✗), settings
- **If user creates account** (optional): email (for circle invites), display name. Nothing else.
- **Never**: dhikr type, count, frequency, location, prayer times, phone model, IP logging

### What we DON'T do

- No analytics SDK (Firebase Analytics removed from v1.0 deps)
- No ad SDK
- No tracking pixels
- No data sharing with any third party
- No cloud backup by default (opt-in only, user-controlled)
- Crash reporting: anonymous, opt-in only (Firebase Crashlytics with explicit consent at first launch)

### Privacy page copy (in-app)

> **Your dhikr is between you and Allah.**
>
> Zikr Vibe stores your counter data on your device only. We don't collect, track, or sell your prayer data — not to advertisers, not to data brokers, not to anyone. We don't even know what dhikr you do.
>
> If you join a Dhikr Circle, other members can only see that you did dhikr today. They cannot see what you counted, how much, or when. You control what's shared.

### App Store / Play Store description includes

> "No ads. No data collection. No subscription traps. Your worship, your phone, your privacy."

### Database schema (circles only — minimal)

```sql
-- Companion circles
CREATE TABLE circles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  admin_id UUID REFERENCES auth.users(id),
  invite_code TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Circle members
CREATE TABLE circle_members (
  circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (circle_id, user_id)
);

-- Daily presence (NOT dhikr data — just "showed up today")
CREATE TABLE daily_presence (
  user_id UUID REFERENCES auth.users(id),
  circle_id UUID REFERENCES circles(id),
  date DATE NOT NULL,
  PRIMARY KEY (user_id, circle_id, date)
);
-- No count column. No dhikr_type column. Just presence.
```

---

## 10. Positioning Statement

### Primary line (App Store + marketing)

> **"Count your dhikr. Nothing else watches."**

**Subline**: *No ads. No data selling. No broken hardware. Just you and your remembrance.*

### Per-competitor positioning

| Against | Positioning |
|---------|------------|
| Muslim Pro | "They sold your location to the US military. We don't even know your location." |
| iQibla | "Their ring breaks. Our app doesn't." |
| Tasbeeh counter apps | "They show you gambling ads during dhikr. We show you nothing but your count." |
| Pillars | "They do prayer tracking. We do dhikr counting. Both ad-free, different focus — complementary." |

### Three promises (in-app onboarding)

1. **Your dhikr is private.** No data collection. No cloud requirement. No analytics on what you pray. Local-first, always.
2. **Your worship is sacred.** No ads — not ever, not even "halal" ads. No gamification. No scores. No judgment. We present your count. You decide what it means.
3. **Your tool is reliable.** Count never resets unexpectedly. Works offline. Battery won't kill your progress. The app does one thing and does it without breaking.

---

## 11. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Flutter vs React Native | — | **Resolved: Flutter** (Tech Architecture doc) |
| 2 | Supabase free tier limits for 10K users? | Claude | Open |
| 3 | App Store review: will Apple flag prayer notifications as "spam"? | Yun | Open |
| 4 | Deep link strategy: pass circle invite through App Store install (deferred deep linking)? | Claude | Open |
| 5 | Prayer time calculation: default for Gulf? (Umm al-Qura KSA, Dubai UAE) | Yun | Open |
| 6 | ~~Leaderboard ranking: consistency vs volume?~~ | — | **Resolved: No leaderboard. Binary check-in only.** |
| 7 | Gender-separated circles: v1.0 or v1.1? | Yun | Open |
| 8 | App Store listing: Arabic or English name? | — | **Resolved: "Zikr Vibe: Tasbih Counter" (EN title + AR keywords in metadata)** |
| 9 | Apple Watch complication: v1.0 or P2? | — | **Resolved: P2, not MVP** |
| 10 | Monetization timing: when to introduce premium skins tier? | Yun | Open — target Month 3 |
| 11 | Circle presence: show "last active: 3 days ago" or just "today/not today"? | Yun | Open — too much info may feel surveillance-like |
| 12 | Privacy page: in-app or link to web? | Claude | Open (Apple requires privacy policy link) |
| 13 | Crash reporting consent: first launch or buried in settings? | Claude | Open — balance data quality vs trust |
| 14 | App name in Arabic markets: "Zikr Vibe" or "ذكر" or both? | Yun | Open — store listing optimization |
| 15 | Explicitly mention Muslim Pro scandal in marketing? | Yun | Open — risky but powerful ("we don't sell your data" implies someone does) |

---

## 12. Timeline & Phasing

### Phase 1: MVP (Weeks 1-6)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **1** | Setup + Core Counter | Flutter project setup, Supabase backend (minimal), optional auth (Apple/Google/Email + skip), Dhikr counter screen (tap, haptic, 33/66/99 milestone, presets, multiple types) |
| **2** | Streak + Calendar | Daily dhikr log, calendar view, streak calculation with mercy day, home screen streak display, profile screen |
| **3** | Companion Circles (presence, not ranking) | Create circle, invite link generation, **binary check-in board**, gentle nudge, WhatsApp share |
| **4** | Prayer + Qibla | Prayer time calculation (adhan_dart), local notifications (opt-in, off by default), Qibla compass, privacy consent dialog |
| **5** | Polish + Invite Flow | UI polish (Islamic aesthetic, skins), deep linking for invites, onboarding flow with 3 privacy promises, invite landing page |
| **6** | Test + Submit | Bug fixes, performance, privacy-focused App Store listing, screenshots, listing copy, submit |

### Phase 2: Growth Features (Weeks 7-10)

- Streak milestone sharing cards (days only, never counts)
- Arabic UI + RTL
- Dark mode polish
- Ramadan mode
- Dhikr audio

### Phase 3: Scale (Months 3-6)

- Premium skins tier ($1.99/mo or $14.99/yr) — ad-free stays free forever
- Imam/Leader mode
- Apple Watch complication
- Advanced calendar analytics
- Hardware ring integration (if SDK available)

### Dependencies

| Dependency | Status | Blocker? |
|------------|--------|----------|
| Apple Developer Account | Yun has it | No |
| Google Play Developer Account | Registered | No |
| Supabase project | Live with schema deployed | No |
| App Store review (1-3 days) | Submit end of Week 6 | Possible delay |
| Islamic design assets (patterns, calligraphy) | Claude generates or open source | No |

---

## 13. Tech Changes from v1 (reference log)

These deltas are already applied in the codebase; documenting here for new contributors:

| Change | Reason |
|--------|--------|
| **Remove Firebase Analytics** | Privacy promise — no tracking of prayer content |
| **Remove Firebase Dynamic Links** | Service deprecated. Use `app_links` (Universal Links / App Links) + self-hosted zikrvibe.com/join/CODE |
| **Keep Firebase Crashlytics** | Opt-in only, with explicit consent dialog at first launch |
| **Keep Firebase Cloud Messaging** | For prayer time notifications only (opt-in), may be replaced by purely local notifications |
| **Supabase: minimal** | Only for companion circles (presence sync). No dhikr data touches the server |
| **Circle data model: presence only** | Server stores: user_id, circle_id, date, did_dhikr (boolean). That's it. No counts, no dhikr types. |
| **Local-first architecture** | Hive is the source of truth. Cloud is opt-in mirror for circles only |

---

## Appendix A: Competitive Positioning

```
                    Privacy / Trust
                         ▲
                         │
              Pillars ●  │  ★ ZIKR VIBE
              (prayer    │  (dhikr + privacy +
               tracker)  │   companionship + free)
                         │
    ◄────────────────────┼────────────────────►
    Basic Counter        │           Full Suite
                         │
      Tasbeeh apps ●     │     ● Muslim Pro
      (basic, ads,       │     (170M users but
       no privacy)       │      2.9★, data scandal)
                         │
         iQibla Life ●   │     ● Athan
         (hardware-locked│     (prayer times only)
          3.5★, buggy)   │
                         ▼
                    Ads / Data Exploitation
```

**Zikr Vibe occupies the trust quadrant: privacy-first + focused dhikr tool.**

## Appendix B: Competitor Pain Points (from real user reviews)

| Competitor | Rating | Fatal Flaw | User Quote |
|-----------|--------|------------|------------|
| Muslim Pro | 2.9★ Trustpilot | Haram ads + sold data to US military + subscription trap | "ads playing at the same time adhan began" |
| iQibla Life | 3.5★ Google Play | BLE disconnect + battery death = data loss + poor build quality | "a well advertised scam selling faulty products bundled with a bad application" |
| Tasbeeh Counter Pro | 4.7★ | Haram ads even after paying + off-by-one bug + no calendar | "paid for premium but still get inappropriate ads" |
| Pillars | 4.8★ | Crashes + white screen + freezes after 5th prayer | "app crashes every time I try to mark my prayer" |

## Appendix C: Validated User Needs (from 2 rounds of research, 2026-04-02)

### Real Needs (daily use, high retention)
| Need | Evidence | Status |
|------|----------|--------|
| Distraction-free counting | "I pick up my phone to count and end up on Instagram" | ✅ P0-1 |
| Zero ads, especially no haram ads | Almost every 1-star review across all competitors | ✅ P0-7, Design Principle #6 |
| 33/66/99 haptic milestones | "I want to close my eyes and feel the count" | ✅ P0-1 |
| Data sovereignty / no selling to military | Muslim Pro scandal still haunts the market | ✅ P0-8, Design Principle #7, Section 9 |
| Persistent counts (don't lose on crash/battery) | iQibla battery death = counts gone | ✅ P0-4, Hive local storage |
| 33-bead progress visualization | Round-of-tasbih rhythm | ✅ P0-1 |
| Mercy day on streak | Duolingo guilt has no place in worship | ✅ P0-6 |
| Calendar view | "One thing to make it 5 stars is having a calendar" (direct quote) | ✅ P0-5 |

### False Needs (sound good but don't work)
| Need | Why It's False |
|------|---------------|
| Social leaderboards | Devout Muslims avoid sharing dhikr counts — riya' (showing off) |
| AI religious insights | Muslim community deeply skeptical of AI interpreting religion |
| Quran reading | 100+ apps do this well already |
| Period tracking | Not a dhikr counter's job |
| Subscription on core | Users traumatized by Muslim Pro traps |

## Appendix D: ASO Keywords

**App Title**: `Zikr Vibe: Tasbih Counter`
**iOS Subtitle**: `Smart Dhikr & Azkar Tracker`
**Google Play Short Desc**: `Smart dhikr & tasbeeh counter with vibration. Track azkar, duas & daily zikr.`
**iOS Keywords**: `tasbeeh,prayer beads,islamic,dua,subhanallah,zikr ring,muslim,daily,free,counter,digital,reminder`

**Tier 1 keywords** (9M+ installs validate demand): tasbih, dhikr, tasbih counter, dhikr counter
**Seasonal**: Update title to include "Ramadan" during Ramadan month (+126% installs in UAE)

See full ASO listing: `docs/Zikr-Vibe-ASO-Listing.md`

---

*"Count your dhikr. Nothing else watches."*
