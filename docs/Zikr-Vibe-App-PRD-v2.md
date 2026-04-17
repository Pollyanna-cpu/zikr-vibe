# Product Requirements Document: Zikr Vibe App v2

**Author**: Yun / Soul Vibe Technology
**Date**: 2026-04-02 (v2 — post-research update)
**Status**: Draft
**Changes from v1**: Group ranking → Group companionship; Privacy elevated to core; 33-milestone haptic added to P0; Social sharing deprioritized

---

## 1. Executive Summary

Zikr Vibe is a **free mobile app** that makes dhikr distraction-free, persistent, and gently communal. No ads. No data collection. No hardware required. Tap the screen to count, feel the vibration at 33, see your consistency over time. Optionally, share presence (not numbers) with a private circle.

**Why now**: Every major Muslim app has betrayed its users — Muslim Pro sold data to the US military, tasbeeh counters show half-naked women in ads, iQibla ships broken hardware. The bar is on the floor. We pick it up by doing the one thing nobody does: respect the user.

---

## 2. What Changed (Research Findings)

### Validated assumptions
- Distraction-free counting is the #1 pain → our core feature
- Ad-free is not a feature, it's table stakes → users feel **violated** by haram ads during dhikr
- iQibla proved demand exists but failed on quality → market is pre-educated
- Simplicity wins → Pillars (4.8★) is praised BECAUSE it's minimal

### Invalidated assumptions
- ~~Group ranking drives viral growth~~ → **Wrong.** Devout Muslims consider sharing dhikr counts as riya' (showing off). The most religious users — our core ICP — would actively avoid a leaderboard. "Ibadah is between you and Allah, not you and a leaderboard."
- ~~Social sharing is a growth engine~~ → **Partially wrong.** Milestone sharing cards might work for younger/casual users, but core users won't share counts publicly.

### New insights
- **Privacy is a weapon**, not just a feature. Muslim Pro's data scandal still echoes. "Your dhikr is between you and Allah, not you and a data broker" is a killer positioning line.
- **33-count vibration** is the single most requested smart feature across all dhikr app reviews. It maps directly to the physical rhythm of tasbih beads.
- **Group companionship** (who showed up today?) is valued. **Group competition** (who did more?) is not.

---

## 3. Objectives & Success Metrics

### Goals
1. Ship MVP to App Store + Google Play in 6 weeks
2. Acquire 10,000 users in first 90 days
3. Achieve 4.8+ star rating (Pillars-level) by being respectful
4. Prove daily retention through habit mechanics, not gamification

### Non-Goals (v1.0)

| Non-Goal | Why |
|----------|-----|
| Monetization | Free removes all friction. Monetize at scale. |
| Leaderboards / rankings | Research says core users consider this riya' |
| Public sharing of dhikr counts | Private worship ≠ social content |
| Quran reading | Muslim Pro / Quran.com own this |
| Hardware integration | No SDK. App must be 100% standalone |
| AI features | Muslim community skeptical of AI in religion |
| Subscription model | Users traumatized by Muslim Pro subscription traps |

### Success Metrics

| Metric | 30 days | 90 days |
|--------|---------|---------|
| Downloads | 2,000 | 10,000 |
| DAU / MAU | 35% | 45% |
| 7-day retention | 40% | 50% |
| 30-day retention | 20% | 30% |
| App Store rating | 4.7+ | 4.8+ |
| Users with ≥1 companion group | 15% | 30% |
| Return/refund rate | N/A (free) | N/A |

### Kill Criteria
- DAU/MAU < 15% after 60 days → core loop broken
- App Store rating < 4.0 after 50 reviews → stop marketing, fix issues
- < 500 downloads after 30 days with effort → market doesn't exist

---

## 4. Core Philosophy

**Three promises to the user:**

1. **Your dhikr is private.** No data collection. No cloud requirement. No analytics on what you pray. Local-first, always.

2. **Your worship is sacred.** No ads — not ever, not even "halal" ads. No gamification. No scores. No judgment. We present your count. You decide what it means.

3. **Your tool is reliable.** Count never resets unexpectedly. Works offline. Battery won't kill your progress. The app does one thing and does it without breaking.

**How this differs from every competitor:**

| | Muslim Pro | iQibla | Tasbeeh apps | **Zikr Vibe** |
|---|---|---|---|---|
| Ads | Haram ads everywhere | In-app upsells | Haram ads even after paying | **Never** |
| Data | Sold to US military | Unknown | Various trackers | **Zero collection** |
| Reliability | Bloated, slow | BLE disconnects, battery kills count | Save button miscounts | **Local-first, persistent** |
| Pricing | $12.99/mo trap | $29-149 hardware | Free with ads | **Free, forever** |

---

## 5. User Stories & Requirements

### P0 — Must Have (MVP, 6 weeks)

| # | Story | Acceptance Criteria | Research Signal |
|---|-------|-------------------|----------------|
| P0-1 | **Tap-to-count** | Full-screen tap zone, count +1 per tap, works offline | Every positive review of every counter app praises simplicity |
| P0-2 | **Haptic at every tap** | Light vibration on each tap, distinct from milestone | "no more struggling with beads" — users want tactile feedback |
| P0-3 | **33-milestone vibration** | Distinct strong vibration at 33, 66, 99, 100. User feels it without looking at screen | #1 most requested feature across all dhikr app reviews. Maps to tasbih cycle |
| P0-4 | **3-5 counter groups** | User-named, independent counts, persist across restart, up to 9999 | "collect all my dhikrs in an app" + "can add your own duaas" |
| P0-5 | **Data persistence** | Counts survive force quit, restart, backgrounding. Local Hive storage | iQibla's #2 complaint: "battery dies, count lost" |
| P0-6 | **Zero ads** | No ad SDK included. Not even ad-ready code. No ad framework in dependencies | "half naked women during dhikr" — the nuclear pain point |
| P0-7 | **Zero data collection** | No analytics on prayer content. No tracking of dhikr types/counts to any server. Optional anonymous crash reporting only | Muslim Pro data scandal. "Between you and Allah, not a data broker" |
| P0-8 | **Swipe to switch groups** | Horizontal swipe changes active counter group | Standard UX, matches tab-bar switching |
| P0-9 | **Long press to reset** | Long press → bottom sheet confirmation → reset to 0 | "when I have to clean the dhikr I have to tap THREE TIMES, drives me nuts" |
| P0-10 | **33-dot progress visual** | 33 small dots showing progress through current tasbih cycle | Visual rhythm of physical beads, unique differentiator |
| P0-11 | **Prayer times** | 5 daily times based on GPS, multiple calculation methods | Expected feature, but keep minimal — not our differentiator |
| P0-12 | **Prayer notifications** | Push notifications, OFF by default, per-prayer toggle | "ads playing at the same time adhan began" — ours will be clean |

### P1 — Should Have (v1.1, weeks 7-10)

| # | Story | Rationale |
|---|-------|-----------|
| P1-1 | **Daily calendar view** | "One thing I think would make it 5 stars is having a calendar" — direct user quote |
| P1-2 | **Streak tracking with mercy day** | Consistency motivation without Duolingo guilt. 1 free freeze per week |
| P1-3 | **Companion groups (presence, not ranking)** | Private circle, see who did dhikr today (✓), NOT how much. No numbers shared |
| P1-4 | **Invite via WhatsApp** | "Join my dhikr circle" — but frame as companionship, not competition |
| P1-5 | **Qibla compass** | Expected feature, low effort, high perceived value |
| P1-6 | **Arabic UI + RTL** | Gulf market primary, Arabic needed for retention |
| P1-7 | **Dark mode** | "night mode didn't work properly" — competitor complaint. Ours should be beautiful |

### P2 — Future (v2.0+)

| # | Story | Notes |
|---|-------|-------|
| P2-1 | **Milestone sharing cards** | For younger/casual users only. Never show raw count — show days, not numbers. "30 days of consistency" not "I did 45,000 dhikr" |
| P2-2 | **Apple Watch** | "would have support for Apple Watch" — real user request |
| P2-3 | **Premium tier** | Ad-free is free forever. Premium = custom themes, advanced calendar, cloud backup. $1.99/mo or $14.99/yr |
| P2-4 | **Ramadan mode** | 30-day challenge, taraweeh tracker, Ramadan-specific milestones |
| P2-5 | **Hardware ring connection** | If SDK becomes available |
| P2-6 | **Gentle nudge notifications** | "You haven't opened Zikr Vibe today" — but ONLY if user opts in, and max 1 per day |

### Explicitly NOT doing

| Feature | Why not |
|---------|--------|
| **Leaderboard / rankings** | Riya' (showing off) — core users would leave |
| **Public count sharing** | ibadah is private |
| **AI dhikr insights** | Muslim community rejects AI in religion |
| **In-app purchases for themes** | Feels extractive in a worship context |
| **Subscription paywall** | Users traumatized by Muslim Pro traps |
| **Any form of advertising** | The #1 reason every competitor gets 1-star reviews |

---

## 6. Companion Groups: Redesigned

### Old Design (v1 — invalidated)
- Group leaderboard ranked by consistency
- Public count comparison
- Competition-driven ("who's most consistent?")
- Viral loop thesis: invite → compete → invite more

### New Design (v2 — research-informed)

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
- How many each person counted (private)
- Rankings or comparisons
- Streaks of other people
- Any judgmental framing

**Rules:**
- Max 10 members per circle (intimate, not broadcast)
- Only shows: name + "did dhikr today" (✓) or "last active: yesterday/3 days ago"
- No numbers, no counts, no streaks of others — only your own
- Circle creator can send one gentle text reminder per day (not automated)
- Leave anytime, no friction

**Why this works:**
1. **Accountability without shame** — you know your family is praying, they know you are. Nobody's graded.
2. **The "empty chair" effect** — seeing "Fatima: yesterday" is a gentle nudge, not a judgment. She might open the app because she wants to show up, not because she's ranked last.
3. **Still viral, but slower** — "Join our family's dhikr circle" is a more natural invite than "Compete with me on dhikr." Lower K-factor, but higher quality users.
4. **Respects riya' concern** — no count sharing, no public performance.

---

## 7. Privacy Architecture

This is a core differentiator, not an afterthought.

### What we collect
- **Device-local only**: counter data, group presence (✓/✗), settings
- **If user creates account**: email (for group invites), display name. Nothing else.
- **Never**: dhikr type, count, frequency, location, prayer times, phone model, IP logging

### What we DON'T do
- No analytics SDK (no Firebase Analytics in v1.0 — remove from deps)
- No ad SDK
- No tracking pixels
- No data sharing with any third party
- No cloud backup by default (opt-in only, user-controlled)
- Crash reporting: anonymous, opt-in only (Firebase Crashlytics with consent)

### Privacy page copy
> **Your dhikr is between you and Allah.**
> Zikr Vibe stores your counter data on your device only. We don't collect, track, or sell your prayer data — not to advertisers, not to data brokers, not to anyone. We don't even know what dhikr you do.
> If you join a Dhikr Circle, other members can only see that you did dhikr today. They cannot see what you counted, how much, or when. You control what's shared.

### App Store description includes
> "No ads. No data collection. No subscription traps. Your worship, your phone, your privacy."

---

## 8. Positioning Statement (Updated)

### For marketing / App Store

**Old**: "Your dhikr. Your hands. Your count." — focused on counting

**New**:

> **"Count your dhikr. Nothing else watches."**

Subline: No ads. No data selling. No broken hardware. Just you and your remembrance.

### Against each competitor

| Against | Positioning |
|---------|------------|
| Muslim Pro | "They sold your location to the US military. We don't even know your location." |
| iQibla | "Their ring breaks. Our app doesn't." |
| Tasbeeh counter apps | "They show you gambling ads during dhikr. We show you nothing but your count." |
| Pillars | "They do prayer tracking. We do dhikr counting. Both ad-free, different focus." |

---

## 9. Tech Changes from v1

| Change | Reason |
|--------|--------|
| **Remove Firebase Analytics** | Privacy promise — no tracking |
| **Remove Firebase Dynamic Links** | Deprecated anyway. Use app-links / universal links instead |
| **Keep Firebase Crashlytics** | But opt-in only, with clear consent dialog |
| **Keep Firebase Cloud Messaging** | For prayer time notifications only |
| **Supabase**: minimal | Only for companion groups (presence sync). No dhikr data touches the server |
| **Group data model**: presence only | Server stores: user_id, group_id, date, did_dhikr (boolean). That's it. No counts. |

### Updated database schema (groups only)

```sql
-- Companion circles (renamed from "groups")
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

## 10. Updated Timeline

| Week | Focus | Changes from v1 |
|------|-------|-----------------|
| **1** | Dhikr counter + auth + local storage | Add 33-milestone vibration |
| **2** | Streak + calendar view | Same |
| **3** | Companion circles (presence, not ranking) | **Completely redesigned** |
| **4** | Prayer times + Qibla | Remove analytics, add privacy consent |
| **5** | Polish + Islamic aesthetic | Add privacy page, "no ads" messaging |
| **6** | Test + submit | Privacy-focused App Store listing |

---

## 11. Open Questions (Updated)

| # | Question | Owner | Impact |
|---|----------|-------|--------|
| 1 | Companion circles: show "last active: 3 days ago" or just "today/not today"? | Yun | Too much info might feel surveillance-like |
| 2 | Privacy page: in-app or link to web? | Claude | Apple requires privacy policy link |
| 3 | Crash reporting consent: first launch or buried in settings? | Claude | Balance between data quality and trust |
| 4 | App name in Arabic markets: "Zikr Vibe" or "ذكر" or both? | Yun | Store listing optimization |
| 5 | Should we explicitly mention Muslim Pro scandal in marketing? | Yun | Risky but powerful. "We don't sell your data" implies someone does |

---

*"Count your dhikr. Nothing else watches."*
