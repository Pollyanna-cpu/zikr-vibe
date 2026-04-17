# Product Requirements Document: Zikr Vibe App

**Author**: Yun / Soul Vibe Technology
**Date**: 2026-04-02
**Status**: Draft
**Stakeholders**: Yun (CEO), Claude (Dev)

---

## 1. Executive Summary

Zikr Vibe is a **free mobile app** for Islamic dhikr (remembrance of Allah) — **distraction-free, private, and consistent**. No hardware required — tap the screen to count, feel the vibration at 33/66/99, see your streak. No ads, no data selling, no judgment. The only dhikr app built around **privacy and companionship** rather than competition.

**Why now**: 1.8B Muslims have no good digital tool for dhikr practice. Muslim Pro (170M+ downloads, 2.9★ Trustpilot) shows haram ads and sold user data to US military contractors. Tasbeeh counter apps are ugly solo tools riddled with ads. iQibla Life requires a $39+ ring with terrible Bluetooth reliability. **The market is large, the incumbents are broken, and the trust gap is wide open.**

**One-line positioning**: *"Count your dhikr. No ads. No data selling. No broken hardware. Just you and your remembrance."*

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

## 3. Objectives & Success Metrics

### Goals

1. **Ship MVP to App Store + Google Play in 6 weeks**
2. **Acquire 10,000 users in first 90 days** (organic + lightweight paid)
3. **Prove companionship groups drive retention** — users in groups retain 2x better than solo users
4. **Establish Zikr Vibe as the #1 privacy-first dhikr app** — own the trust gap Muslim Pro left behind

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

### Success Metrics

| Metric | Target (30 days) | Target (90 days) | Measurement |
|--------|-----------------|-----------------|-------------|
| Downloads | 2,000 | 10,000 | App Store Connect + Google Play Console |
| DAU / MAU ratio | 30% | 40% | Firebase Analytics |
| Companionship groups created | 200 | 1,500 | Backend |
| Avg group size | 3 | 5 | Backend |
| Invites sent per group creator | 4 | 6 | Backend |
| Invite → Install conversion | 15% | 25% | Deep link tracking |
| 7-day retention | 35% | 45% | Firebase |
| 30-day retention | 15% | 25% | Firebase |
| Users in groups vs solo | 40% | 60% | Backend |
| Daily check-in rate (group members) | 50% | 70% | Backend |
| App Store rating | 4.5+ | 4.5+ | App Store / Play Store |

### Kill Criteria

- DAU/MAU < 15% after 60 days → Core engagement loop is broken
- Group users don't retain better than solo → Companionship thesis is wrong, pivot
- < 500 downloads after 30 days with marketing effort → Market doesn't exist

---

## 4. Target Users & Segments

### Primary: Gulf Practicing Muslim Men (UAE/KSA)

| Attribute | Detail |
|-----------|--------|
| Age | 25-45 |
| Location | UAE, KSA, Qatar |
| Faith practice | Prays 5x daily, does dhikr regularly |
| Tech behavior | iPhone or Android, uses WhatsApp daily, has Muslim Pro installed |
| Motivation | Wants to be more consistent in dhikr, wants community accountability |
| Current solution | Physical beads + maybe a basic counter app |
| Language | English (primary), Arabic (secondary) |

### Secondary: Global Practicing Muslims

| Segment | Priority | Notes |
|---------|----------|-------|
| SEA Muslims (Malaysia, Indonesia) | v1.1 | Bahasa localization needed |
| Western diaspora (US, UK, Canada) | v1.0 | English works |
| Women | v1.0 | Same features, may need gender-separated groups option |
| Youth (18-24) | v1.0 | Most likely to adopt social features + share milestones |
| Ramadan-focused | Seasonal | Casual users who engage during Ramadan only |

### User Archetypes

**1. Ahmad the Consistent** — 35, Dubai, prays 5x daily, wants to track his dhikr streak and stay accountable. Currently uses physical beads. Would love to see his 365-day progress.

**2. Omar the Companion** — 28, Riyadh, has a mosque study group of 8 friends. Wants to gently keep each other accountable: "Did everyone do their dhikr today?" Not who did more — just who showed up. Currently uses a WhatsApp group to check in manually.

**3. Fatima the Returner** — 32, London, trying to rebuild her prayer practice after years away. Wants a gentle, non-judgmental tool that shows progress without shame. Doesn't want an app that scores or grades her.

**4. Yusuf the Gifter** — 40, Jeddah, wants to invite his teenage son to a family dhikr group for Ramadan. Needs the app to be simple enough for a 15-year-old.

---

## 5. User Stories & Requirements

### P0 — Must Have (MVP, ship in 6 weeks)

| # | User Story | Acceptance Criteria |
|---|-----------|-------------------|
| P0-1 | **Dhikr Counter**: As a Muslim, I want to tap the screen to count my dhikr so I don't lose count without getting distracted by my phone | - Full-screen tap zone (large, easy to hit) - Light haptic per tap + **strong distinct vibration at 33/66/99 milestones** (eyes-closed tasbih — user research: "I want to close my eyes and just feel the count") - Count displayed prominently - 33-bead progress visualization (circular dots showing position in current round) - Reset button with confirmation - Supports portrait mode (one-hand use) - **Distraction-free**: minimal UI chrome during active counting, no notifications overlay |
| P0-2 | **Preset Targets**: As a user, I want to select dhikr presets (33, 66, 99, 100) so I complete my sets accurately | - 4 preset buttons + custom number input - Vibration alert when target reached - Auto-reset option after target hit - Shows progress ring/bar toward target |
| P0-3 | **Multiple Dhikr Types**: As a user, I want to switch between dhikr types (SubhanAllah, Alhamdulillah, Allahu Akbar, La ilaha illallah, custom) | - Pre-loaded 4 core dhikr types with Arabic text + transliteration - Custom dhikr: user enters text + optional target - Each type tracks count independently - Quick switch between types |
| P0-4 | **Daily Dhikr Log**: As a user, I want my daily dhikr counts saved automatically so I can see my history | - Auto-save every session to local + cloud - Daily total across all dhikr types - Calendar view showing dhikr days (green) vs missed days - Weekly/monthly summary |
| P0-5 | **Streak Tracking**: As a user, I want to see my current streak (consecutive days with dhikr) so I stay motivated | - Current streak count displayed on home screen - Longest streak record - Streak milestones: 7, 30, 100, 365 days - Streak resets if no dhikr recorded by midnight local time |
| P0-6 | **Create Group**: As a user, I want to create a dhikr group and name it so I can track with friends | - Create group with name + optional description - Group creator is admin - Max 50 members per group (v1.0) - User can be in up to 5 groups |
| P0-7 | **Invite to Group**: As a user, I want to invite friends via WhatsApp/SMS link so they join my group | - Generate shareable invite link - Pre-written WhatsApp message: "Join my dhikr circle on Zikr Vibe — [link]" - Link opens app (if installed) or App Store/Play Store (if not) - Invited user auto-joins group on first login |
| P0-8 | **Group Companionship Board**: As a group member, I want to see who did their dhikr today — not how much, just that they showed up | - Binary check-in: ✓ (did dhikr today) or empty (not yet) — **no counts, no ranking, no competition** - Shows each member's current streak (number only, no comparison) - Gentle nudge: if a member hasn't done dhikr by evening, option to send a private "thinking of you" tap - Weekly view: calendar grid showing who was active which days - **Design rationale**: ibadah is between you and Allah. Public counting is riya' (showing off). Companionship = "I know you're on this path too", not "I did more than you" |
| P0-9 | **Prayer Times**: As a Muslim, I want to see today's 5 prayer times based on my location | - Auto-detect location (GPS) - Show Fajr, Dhuhr, Asr, Maghrib, Isha times - Calculation method selector (Umm al-Qura, ISNA, Muslim World League, etc.) - Next prayer countdown |
| P0-10 | **Prayer Notifications**: As a user, I want push notifications before each prayer so I don't miss | - Configurable: X minutes before each prayer - Per-prayer toggle (enable/disable individually) - Notification sound options (adhan clip or silent) - Respects Do Not Disturb |
| P0-11 | **Auth + Profile**: As a user, I want to sign up and have my data synced across devices | - Sign up with Apple / Google / Email - Display name + optional avatar - Data syncs via backend - Profile shows: total lifetime dhikr, current streak, groups |
| P0-12 | **Qibla Compass**: As a user, I want to see the direction of Mecca from my current location | - Uses device compass + GPS - Arrow pointing to Kaaba - Distance to Mecca displayed - Accuracy indicator |

### P1 — Should Have (v1.1, weeks 7-10)

| # | User Story | Acceptance Criteria |
|---|-----------|-------------------|
| P1-1 | **Streak Milestone Cards**: As a user, I want to share my streak (not count) as a beautiful card on WhatsApp/IG | - Auto-generated card at streak milestones (7/30/100/365 consecutive days) - **Shows streak days only, NOT dhikr counts** (respects riya' concern) - Message: "I remembered Allah for 30 days straight" not "I did 99,000 dhikr" - Islamic geometric design aesthetic - One-tap share to WhatsApp/IG Stories - Subtle Zikr Vibe branding + download CTA |
| P1-2 | **Group Invitation Cards**: As a group creator, I want a beautiful invite card to bring friends into my dhikr circle | - "Join our dhikr circle on Zikr Vibe" - Shows group name + member count - Does NOT show any individual stats - Pre-written WhatsApp message with deep link |
| P1-3 | **Arabic UI**: As an Arabic-speaking user, I want the app in Arabic with RTL layout | - Full Arabic translation - RTL layout support - Arabic numerals option |
| P1-4 | **Invite Landing Page**: As an invited user, I want to see what this dhikr circle is about before downloading | - Web page showing group name + member count + "X members remembered Allah today" - Privacy-first messaging: "Your data stays on your device" - "Download to Join" CTA with App Store / Play Store links - Deep link passes group invite code through install |
| P1-5 | **Dhikr Audio**: As a user, I want optional audio for each dhikr type so I can follow along | - Audio pronunciation for each preset dhikr - Play/pause control - Auto-advance option (plays next dhikr after target hit) |
| P1-6 | **Ramadan Mode**: As a user, I want a special Ramadan experience with daily goals and Taraweeh tracking | - Ramadan calendar with daily dhikr goals - Taraweeh prayer tracker - Ramadan-specific milestone cards - Auto-activates during Ramadan dates |

### P2 — Nice to Have / Future (v2.0+)

| # | User Story | Acceptance Criteria |
|---|-----------|-------------------|
| P2-1 | **Hardware Ring Integration** | Connect Zikr Vibe ring (if SDK becomes available) for automatic dhikr counting |
| P2-2 | **Premium Tier** | Ad-free, advanced analytics, unlimited groups, custom group themes. $2.99/mo or $19.99/yr |
| P2-3 | **Imam/Leader Mode** | Group admin can set weekly dhikr goals, send encouragement messages, pin announcements |
| P2-4 | **Wrist Widget** | Apple Watch / Wear OS complication for quick dhikr counting |
| P2-5 | **Offline Mode** | Full dhikr counting works offline, syncs when reconnected |
| P2-6 | **Family Groups** | Parent-child groups with simplified UI for kids |
| P2-7 | **Mosque Directory** | Find nearby mosques with group join suggestions |
| P2-8 | **Dhikr Insights** | Weekly summary: "You did 2,340 dhikr this week, 15% more than last week" (data presentation, not judgment) |

---

## 6. Solution Overview

### Architecture

```
┌─────────────────────────────────────┐
│          MOBILE APP                  │
│    (React Native or Flutter)         │
│                                      │
│  ┌──────────┐  ┌──────────────────┐ │
│  │  Dhikr   │  │  Companionship   │ │
│  │  Counter  │  │  Groups (binary) │ │
│  └──────────┘  └──────────────────┘ │
│  ┌──────────┐  ┌──────────────────┐ │
│  │  Prayer  │  │  Streak Tracker  │ │
│  │  Times   │  │  + Milestones    │ │
│  └──────────┘  └──────────────────┘ │
│  ┌──────────┐  ┌──────────────────┐ │
│  │  Qibla   │  │  Profile +       │ │
│  │  Compass  │  │  Auth            │ │
│  └──────────┘  └──────────────────┘ │
└──────────────────┬──────────────────┘
                   │ API
┌──────────────────▼──────────────────┐
│           BACKEND                    │
│         (Supabase)                   │
│                                      │
│  Auth (Apple/Google/Email)           │
│  PostgreSQL (users, groups, dhikr)   │
│  Realtime (leaderboard updates)      │
│  Edge Functions (invite links,       │
│    prayer time calc, milestones)     │
│  Storage (avatar images,             │
│    milestone card generation)        │
└──────────────────────────────────────┘
```

### Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Framework | **Flutter** | Single codebase for iOS + Android. Faster than React Native for UI-heavy apps. Claude can generate Dart |
| Backend | **Supabase** | Already used for Soul Alchemy. Auth, DB, Realtime, Edge Functions in one platform. Free tier generous |
| Prayer time calc | **Adhan library** (open source) | Well-maintained, supports all calculation methods. Don't reinvent |
| Qibla | **Device compass + GPS** | Standard sensor APIs, no external dependency |
| Deep linking | **Firebase Dynamic Links** or **Branch.io** | Critical for invite flow (WhatsApp → App Store → auto-join group) |
| Push notifications | **Firebase Cloud Messaging** | Cross-platform, free, reliable |
| Milestone cards | **Server-side image generation** | Supabase Edge Function generates PNG → app shares to WhatsApp/IG |

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
7. **Privacy by default** — All dhikr data stored locally (Hive). Cloud sync is opt-in for groups only. No analytics on prayer content. No third-party data sharing. Period.
8. **Companionship over competition** — Group features show presence (✓ did dhikr today), never volume. Ibadah is between you and Allah.

---

## 7. Open Questions

| # | Question | Owner | Deadline | Status |
|---|----------|-------|----------|--------|
| 1 | Flutter vs React Native — Claude's strongest framework? | Claude | Week 1 | **Decision: Flutter** (in Tech Architecture doc) |
| 2 | Supabase free tier limits for 10K users? | Claude | Week 1 | Open |
| 3 | App Store review: will Apple flag prayer notifications as "spam"? | Yun | Week 2 | Open |
| 4 | Deep link strategy: how to pass group invite through App Store install? | Claude | Week 2 | Open |
| 5 | Prayer time calculation: which method as default for Gulf? (Umm al-Qura for KSA, Dubai for UAE) | Yun | Week 1 | Open |
| 6 | ~~Leaderboard ranking: consistency vs volume?~~ | — | — | **Resolved: No leaderboard. Binary check-in only (did dhikr today ✓). Research killed ranking.** |
| 7 | Gender-separated groups: required for v1.0 or v1.1? | Yun | Week 1 | Open |
| 8 | App Store listing: Arabic or English name? | — | — | **Resolved: "Zikr Vibe: Tasbih Counter" (English). ASO research shows English title + Arabic keywords in metadata.** |
| 9 | Apple Watch complication: include in v1.0? (Flutter support limited) | Claude | Week 1 | **Decision: P2. Not MVP.** |
| 10 | Monetization timing: when to introduce premium tier? | Yun | Month 3 | Open |

---

## 8. Timeline & Phasing

### Phase 1: MVP (Weeks 1-6)

| Week | Focus | Deliverables |
|------|-------|-------------|
| **1** | Setup + Core Counter | Flutter project setup, Supabase backend, Auth (Apple/Google/Email), Dhikr counter screen (tap, haptic, presets, multiple types) |
| **2** | Data + Streaks | Daily dhikr log, calendar view, streak calculation, home screen streak display, profile screen |
| **3** | Groups + Ranking | Create group, invite link generation, group leaderboard, join flow, WhatsApp share |
| **4** | Prayer + Qibla | Prayer time calculation, push notifications, Qibla compass, prayer times screen |
| **5** | Polish + Invite Flow | UI polish (Islamic aesthetic), deep linking for invites, onboarding flow, invite landing page |
| **6** | Test + Submit | Bug fixes, performance, App Store + Play Store submission, screenshots, listing copy |

### Phase 2: Growth Features (Weeks 7-10)

- Milestone sharing cards (Islamic design)
- Group milestones
- Arabic UI + RTL
- Ramadan mode
- Dhikr audio

### Phase 3: Scale (Months 3-6)

- Premium tier ($2.99/mo)
- Imam/Leader mode
- Apple Watch
- Advanced analytics
- Hardware ring integration (if SDK available)

### Dependencies

| Dependency | Status | Blocker? |
|------------|--------|----------|
| Apple Developer Account | Yun has it | No |
| Google Play Developer Account | Needed ($25 one-time) | Minor |
| Supabase project | Create new (separate from Soul Alchemy) | No |
| App Store review (1-3 days) | Submit end of Week 6 | Possible delay |
| Islamic design assets (patterns, calligraphy) | Claude generates or open source | No |

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
| Zero ads, especially no haram ads | Almost every 1-star review across all competitors | ✅ Design Principle #6 |
| 33/66/99 haptic milestones | "I want to close my eyes and feel the count" | ✅ P0-1 |
| Data sovereignty / no selling to military | Muslim Pro scandal still haunts the market | ✅ Design Principle #7 |
| Persistent counts (don't lose on crash/battery) | iQibla battery death = counts gone | ✅ Hive local storage |
| 33-bead progress visualization | Round-of-tasbih rhythm | ✅ P0-1 |

### False Needs (sound good but don't work)
| Need | Why It's False |
|------|---------------|
| Social leaderboards | Devout Muslims avoid sharing dhikr counts — riya' (showing off) |
| AI religious insights | Muslim community deeply skeptical of AI interpreting religion |
| Quran reading | 100+ apps do this well already |
| Period tracking | Not a dhikr counter's job |

## Appendix D: ASO Keywords

**App Title**: `Zikr Vibe: Tasbih Counter`
**iOS Subtitle**: `Smart Dhikr & Azkar Tracker`
**Google Play Short Desc**: `Smart dhikr & tasbeeh counter with vibration. Track azkar, duas & daily zikr.`
**iOS Keywords**: `tasbeeh,prayer beads,islamic,dua,subhanallah,zikr ring,muslim,daily,free,counter,digital,reminder`

**Tier 1 keywords** (9M+ installs validate demand): tasbih, dhikr, tasbih counter, dhikr counter
**Seasonal**: Update title to include "Ramadan" during Ramadan month (+126% installs in UAE)

---

*"The best growth engine isn't an ad. It's a friend saying: I remembered Allah today. Join me."*
