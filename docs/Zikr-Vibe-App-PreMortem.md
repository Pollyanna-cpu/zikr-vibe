# Pre-Mortem: Zikr Vibe App

**Date**: 2026-04-02 (canonical) — updated 2026-04-24 for companionship/privacy pivot
**Status**: Canonical
**Scenario**: It's 90 days post-launch. Zikr Vibe has 500 downloads instead of 3,000. What went wrong?

---

## Risk Summary

- **Tigers**: 12 (3 launch-blocking, 5 fast-follow, 4 track)
- **Paper Tigers**: 4
- **Elephants**: 3

**Note**: v1 of this pre-mortem targeted 10K downloads in 90 days built on the ranking/viral thesis. Canonical target is 3K (post-research conservative model: see GrowthLoops canonical). Risks updated accordingly.

---

## Launch-Blocking Tigers

These must be resolved before submitting to App Store. Ship without mitigation = launch failure.

| # | Risk | Likelihood | Impact | Mitigation | Owner | Deadline |
|---|------|-----------|--------|-----------|-------|----------|
| T1 | **Deep link breaks through App Store install** — User clicks WhatsApp invite → goes to App Store → installs → but circle invite code is lost. Circle Loop dead on arrival. | HIGH | CRITICAL | Use `app_links` (Universal Links / App Links) with self-hosted `zikrvibe.com/join/CODE` redirect. **Firebase Dynamic Links is deprecated (Aug 2025) — do NOT use.** Test the FULL flow (WhatsApp → Store → Install → Auto-join circle) on both iOS and Android before launch. This is THE growth mechanism for the Circle Loop — if it doesn't work, Trust Loop still runs but slower. | Claude | Week 4 |
| T2 | **Prayer time calculation is wrong** — Off by even 5 minutes and you lose all trust instantly. A Muslim using your app to not miss Fajr (pre-dawn prayer) will never come back if the notification fires late. | HIGH | CRITICAL | Use battle-tested open-source library (adhan-dart or adhan-js). Default to Umm al-Qura method for KSA, Dubai method for UAE. Test against Muslim Pro and Athan for the same location — must match within 1 minute. Include manual timezone override. | Claude | Week 4 |
| T3 | **App Store rejection for notification spam** — Apple has rejected prayer/reminder apps for "excessive notifications" (5 per day looks aggressive to a non-Muslim reviewer). | MED | CRITICAL | Pre-emptively explain in App Review Notes: "This app sends 5 daily notifications aligned with Islamic prayer times — this is the core religious use case, similar to Muslim Pro (100M+ downloads)." Have prayer notifications OFF by default, user opts-in during onboarding. Include link to Muslim Pro as precedent. | Yun | Week 6 |

---

## Fast-Follow Tigers

Won't block launch, but must be addressed within first 2 weeks post-launch or they'll kill retention.

| # | Risk | Likelihood | Impact | Planned Response | Owner |
|---|------|-----------|--------|-----------------|-------|
| T4 | **"Empty circle" problem** — User downloads, creates a circle, invites friends. Friends don't download. User sees empty check-in board. Feels alone. Churns. | HIGH | HIGH | Pre-populate with "Join an Open Circle" option (Zikr Vibe official circle, regional circles). During onboarding, show example circle with ✓/· presence (not ranking). Gentle re-engagement push: "Ahmad invited you to a dhikr circle" to pending invites. **Critical**: Solo mode must be a complete experience on its own — the app must feel worth using before you invite anyone. | Claude |
| T5 | **Streak anxiety instead of motivation** — User misses one day, loses 47-day streak, feels terrible, uninstalls. The "Duolingo guilt" problem. | MED | HIGH | Implement "mercy day" — 1 free streak freeze per week (auto-applied). Show "longest streak" alongside current streak so a break doesn't erase history. Never use shame language. Philosophy: present data, never judge. | Claude |
| T6 | **Dhikr counter feels worse than beads** — Tapping a screen has no tactile satisfaction compared to physical beads. If the counting experience isn't better, there's no reason to switch. | MED | HIGH | Light haptic on every tap + **strong distinct vibration at 33/66/99 milestones** (eyes-closed tasbih). 33-bead progress dots visualize rhythm. Beautiful count animation. Counter must feel GOOD, not just functional. Test with 5 real users before launch. | Claude |
| T7 | **Any form of count ranking surfaces accidentally** — A developer adds "most active this week" or "circle total" feature thinking it's harmless. Devout Muslims flag it as riya'. App gets 1-star religious review. | MED | HIGH | **Code-level enforcement**: no `COUNT(*)` or `SUM(count)` queries on dhikr data anywhere. Schema has no dhikr_count column on server (see Privacy Architecture). Only `daily_presence` (boolean). If a well-meaning dev tries to add "your circle counted 5,000 today", the data literally does not exist server-side. Protection by architecture, not by policy. | Claude |
| T8 | **No Arabic = no virality in Gulf** — App launches in English only. Gulf users share invite links but recipients see English UI and bounce. | MED | MED | Prepare Arabic translation + RTL layout as Week 7-8 priority. Use Arabic in WhatsApp invite message templates even if app UI is English at launch. Add Arabic App Store listing from Day 1 (separate from in-app language). | Claude |

---

## Track Tigers

Monitor post-launch. Take action if trigger condition is met.

| # | Risk | Trigger Condition | Response |
|---|------|------------------|----------|
| T9 | **Supabase free tier hits limits** | >10K MAU or >500MB database or >2GB bandwidth | Upgrade to Pro ($25/mo). Pre-monitor usage weekly. |
| T10 | **iQibla adds social features** | iQibla Life app update adds any social leaderboard or circle feature | They'll do ranking (wrong). Our advantage is privacy-first + companionship. If they copy the circle design, we still have the trust moat (their data scandal risk). Stay focused on product depth. |
| T11 | **Muslim Pro adds dhikr counter** | Muslim Pro update with dhikr counting feature | They'll do it as a feature, not a product. Our depth (groups, streaks, milestones) wins vs their breadth. Stay focused. |
| T12 | **App Store rating drops below 4.0** | First 50 reviews average < 4.0 | Stop all marketing. Fix top complaints. Re-launch when rating recovers. Early reviews set the trajectory. |

---

## Paper Tigers

Risks that feel scary but are manageable.

| # | Concern | Why It's Manageable |
|---|---------|-------------------|
| PT1 | **"Claude can't build a real app"** | Claude has already built Soul Alchemy (Next.js + Stripe + Claude API) and Soul Vibe Band App (Swift + BLE SDK). Flutter is well within capability. The bottleneck is design quality, not code. |
| PT2 | **"No budget for marketing"** | The entire growth thesis is organic (Trust Loop + Circle Loop via WhatsApp). Pillars grew to ~1M on zero budget via Muslim Twitter. Muslim Pro grew to 100M+ largely through word-of-mouth. If the product is good and privacy-first, mosque WhatsApp groups ARE the distribution channel. $0 marketing is the plan, not a constraint. |
| PT3 | **"6 weeks is too fast for a good app"** | MVP scope is tight: counter + groups + prayer times + streaks. No Quran, no health features, no marketplace. Four screens, one backend. 6 weeks is aggressive but achievable if scope doesn't creep. The real risk is scope creep, not timeline. |
| PT4 | **"Religious sensitivity will get us cancelled"** | The app does ONE thing: count dhikr. It doesn't interpret scripture, issue fatwas, or claim religious authority. "Tap to count SubhanAllah" is about as inoffensive as technology gets. Risk becomes real only if we add AI-generated religious content (which we won't in v1.0). |

---

## Elephants in the Room

Uncomfortable truths that need to be discussed honestly.

### Elephant 1: "We're pivoting again"

Zikr Vibe started as a hardware ring. Now it's a pure software app. The ring may never connect to this app (no SDK). This is actually the right move — but it means the hardware inventory (if any ordered) becomes a separate product line, not the core business. **The conversation to have**: "Is the ring dead, or does it become an optional accessory?" If it's an accessory, the packaging, marketing, and Shopify store all need to reflect that the app is primary.

### Elephant 2: "One-person dev team = single point of failure"

Claude writes the code. Yun reviews. There is no backup engineer, no code review, no QA team. If a critical bug hits at 2am Gulf time (peak usage after Isha prayer), response time depends on one person waking up. **The conversation to have**: Set up crash reporting (Firebase Crashlytics) from Day 1. Accept that v1.0 will have bugs. Have a "known issues" page ready. Users forgive bugs in a free app if you fix them fast.

### Elephant 3 (resolved): "Group ranking won't work for devout Muslims"

**Addressed in 2026-04-02 research**: v1 of this pre-mortem flagged that ranking-for-worship might feel inappropriate. User research confirmed: devout Muslims consider sharing dhikr counts as riya' (showing off). The entire ranking thesis is dead.

**Canonical response**: Circles are **companionship, not competition**. Binary check-in (✓/✗), no counts, no ranking. See PRD §8 (Companion Circles Redesigned). The risk that remains: circles might feel *too* minimal and users ignore them. Mitigation: solo mode is a complete, satisfying experience on its own. If <15% of users create/join circles after 30 days, the circle thesis needs rethinking — but the core app still works as the best privacy-first dhikr counter.

---

## Go/No-Go Checklist

### Before App Store submission (Week 6):

- [ ] Deep link flow tested end-to-end: WhatsApp → App Store → Install → Auto-join circle (iOS + Android) — via `app_links`, NOT Firebase Dynamic Links
- [ ] Prayer times verified against Muslim Pro for 5 cities: Dubai, Riyadh, Jeddah, London, New York (within 1 min)
- [ ] App Review Notes prepared explaining 5 daily prayer notifications
- [ ] Prayer notifications default OFF, user opts-in
- [ ] Dhikr counter: light haptic per tap + **strong 33/66/99 vibration** tested on iPhone 12+ and recent Android devices
- [ ] 33-bead progress dots render correctly
- [ ] Circle Companionship Board shows **only** ✓/· (no counts, no ranks anywhere in UI)
- [ ] Streak includes 1 "mercy day" freeze per week
- [ ] **Zero ads verified**: no ad SDK in `pubspec.yaml`, no ad framework code paths
- [ ] **Zero dhikr data on server**: schema has no `count` column in server tables, only `daily_presence` boolean
- [ ] Firebase Analytics **removed** from deps (privacy promise)
- [ ] Firebase Crashlytics opt-in only, explicit consent dialog at first launch
- [ ] "Join an Open Circle" option available for new users
- [ ] Arabic App Store listing (title + description + keywords) ready
- [ ] WhatsApp invite message template in both English and Arabic (companionship framing, not competition)
- [ ] Privacy policy and Terms of Service pages live — language matches Three Promises (your dhikr is private / your worship is sacred / your tool is reliable)
- [ ] No religious claims, no fatwa language, no "Islamic certification" anywhere in app or listing

### Post-launch monitoring (Week 7-8):

- [ ] Daily check: crash rate, prayer time accuracy reports, App Store reviews
- [ ] Weekly check: DAU/MAU, group creation rate, invite conversion, Supabase usage
- [ ] Respond to every 1-2 star review within 24 hours
- [ ] Arabic UI ready to ship by Week 8

---

**Overall Assessment: GO with caution.**

The 3 launch-blockers (deep linking, prayer times, App Store review) are all solvable with known techniques. The elephants are real but don't change the fundamental thesis. The biggest meta-risk is scope creep during the 6 weeks — ruthlessly cut anything not in P0.

---

*"The team that does the pre-mortem doesn't need the post-mortem."*
