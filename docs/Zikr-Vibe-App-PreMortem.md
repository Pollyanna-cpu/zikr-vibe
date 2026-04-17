# Pre-Mortem: Zikr Vibe App

**Date**: 2026-04-02
**Status**: Draft
**Scenario**: It's 90 days post-launch. Zikr Vibe has 800 downloads instead of 10,000. What went wrong?

---

## Risk Summary

- **Tigers**: 12 (3 launch-blocking, 5 fast-follow, 4 track)
- **Paper Tigers**: 4
- **Elephants**: 3

---

## Launch-Blocking Tigers

These must be resolved before submitting to App Store. Ship without mitigation = launch failure.

| # | Risk | Likelihood | Impact | Mitigation | Owner | Deadline |
|---|------|-----------|--------|-----------|-------|----------|
| T1 | **Deep link breaks through App Store install** — User clicks WhatsApp invite → goes to App Store → installs → but group invite code is lost. Growth loop is dead on arrival. | HIGH | CRITICAL | Use Firebase Dynamic Links with deferred deep linking. Test the FULL flow (WhatsApp → Store → Install → Auto-join) on both iOS and Android before launch. This is THE growth mechanism — if it doesn't work, nothing else matters. | Claude | Week 4 |
| T2 | **Prayer time calculation is wrong** — Off by even 5 minutes and you lose all trust instantly. A Muslim using your app to not miss Fajr (pre-dawn prayer) will never come back if the notification fires late. | HIGH | CRITICAL | Use battle-tested open-source library (adhan-dart or adhan-js). Default to Umm al-Qura method for KSA, Dubai method for UAE. Test against Muslim Pro and Athan for the same location — must match within 1 minute. Include manual timezone override. | Claude | Week 4 |
| T3 | **App Store rejection for notification spam** — Apple has rejected prayer/reminder apps for "excessive notifications" (5 per day looks aggressive to a non-Muslim reviewer). | MED | CRITICAL | Pre-emptively explain in App Review Notes: "This app sends 5 daily notifications aligned with Islamic prayer times — this is the core religious use case, similar to Muslim Pro (100M+ downloads)." Have prayer notifications OFF by default, user opts-in during onboarding. Include link to Muslim Pro as precedent. | Yun | Week 6 |

---

## Fast-Follow Tigers

Won't block launch, but must be addressed within first 2 weeks post-launch or they'll kill retention.

| # | Risk | Likelihood | Impact | Planned Response | Owner |
|---|------|-----------|--------|-----------------|-------|
| T4 | **"Empty room" problem** — User downloads, creates a group, invites friends. Friends don't download. User sees empty leaderboard. Feels pointless. Churns. | HIGH | HIGH | Pre-populate with "Join a Public Group" option (Zikr Vibe official group, regional groups). Show sample leaderboard during onboarding. Send re-engagement push: "Ahmad invited you but you haven't joined yet!" to pending invites. | Claude |
| T5 | **Streak anxiety instead of motivation** — User misses one day, loses 47-day streak, feels terrible, uninstalls. The "Duolingo guilt" problem. | MED | HIGH | Implement "mercy day" — 1 free streak freeze per week (auto-applied). Show "longest streak" alongside current streak so a break doesn't erase history. Never use shame language. Philosophy: present data, never judge. | Claude |
| T6 | **Dhikr counter feels worse than beads** — Tapping a screen has no tactile satisfaction compared to physical beads. If the counting experience isn't better, there's no reason to switch. | MED | HIGH | Strong haptic feedback (different vibration for each tap vs target reached). Satisfying sound options (subtle click, muted tap). Beautiful count animation. The counter must feel GOOD, not just functional. Test with 5 real users before launch. | Claude |
| T7 | **Leaderboard ranked by volume, not consistency — creates toxic competition** — If ranking = highest raw count, users will leave the app running with auto-tap tools, or inflate numbers. Ruins trust. | MED | MED | Rank by CONSISTENCY (days active / total days) not VOLUME (total count). A user who does 33 dhikr every day for 30 days ranks higher than someone who does 10,000 in one day. Display both metrics but rank on consistency. | Claude |
| T8 | **No Arabic = no virality in Gulf** — App launches in English only. Gulf users share invite links but recipients see English UI and bounce. | MED | MED | Prepare Arabic translation + RTL layout as Week 7-8 priority. Use Arabic in WhatsApp invite message templates even if app UI is English at launch. Add Arabic App Store listing from Day 1 (separate from in-app language). | Claude |

---

## Track Tigers

Monitor post-launch. Take action if trigger condition is met.

| # | Risk | Trigger Condition | Response |
|---|------|------------------|----------|
| T9 | **Supabase free tier hits limits** | >10K MAU or >500MB database or >2GB bandwidth | Upgrade to Pro ($25/mo). Pre-monitor usage weekly. |
| T10 | **iQibla copies group ranking** | iQibla Life app update adds social leaderboard | Accelerate milestone sharing cards + Ramadan mode. Our advantage shifts from "only social dhikr" to "best social dhikr" — execution speed matters. |
| T11 | **Muslim Pro adds dhikr counter** | Muslim Pro update with dhikr counting feature | They'll do it as a feature, not a product. Our depth (groups, streaks, milestones) wins vs their breadth. Stay focused. |
| T12 | **App Store rating drops below 4.0** | First 50 reviews average < 4.0 | Stop all marketing. Fix top complaints. Re-launch when rating recovers. Early reviews set the trajectory. |

---

## Paper Tigers

Risks that feel scary but are manageable.

| # | Concern | Why It's Manageable |
|---|---------|-------------------|
| PT1 | **"Claude can't build a real app"** | Claude has already built Soul Alchemy (Next.js + Stripe + Claude API) and Soul Vibe Band App (Swift + BLE SDK). Flutter is well within capability. The bottleneck is design quality, not code. |
| PT2 | **"No budget for marketing"** | The entire growth thesis is organic (group invites via WhatsApp). Muslim Pro grew to 100M+ largely through word-of-mouth in Muslim communities. If the product is good, mosque WhatsApp groups ARE the distribution channel. $0 marketing is the plan, not a constraint. |
| PT3 | **"6 weeks is too fast for a good app"** | MVP scope is tight: counter + groups + prayer times + streaks. No Quran, no health features, no marketplace. Four screens, one backend. 6 weeks is aggressive but achievable if scope doesn't creep. The real risk is scope creep, not timeline. |
| PT4 | **"Religious sensitivity will get us cancelled"** | The app does ONE thing: count dhikr. It doesn't interpret scripture, issue fatwas, or claim religious authority. "Tap to count SubhanAllah" is about as inoffensive as technology gets. Risk becomes real only if we add AI-generated religious content (which we won't in v1.0). |

---

## Elephants in the Room

Uncomfortable truths that need to be discussed honestly.

### Elephant 1: "We're pivoting again"

Zikr Vibe started as a hardware ring. Now it's a pure software app. The ring may never connect to this app (no SDK). This is actually the right move — but it means the hardware inventory (if any ordered) becomes a separate product line, not the core business. **The conversation to have**: "Is the ring dead, or does it become an optional accessory?" If it's an accessory, the packaging, marketing, and Shopify store all need to reflect that the app is primary.

### Elephant 2: "One-person dev team = single point of failure"

Claude writes the code. Yun reviews. There is no backup engineer, no code review, no QA team. If a critical bug hits at 2am Gulf time (peak usage after Isha prayer), response time depends on one person waking up. **The conversation to have**: Set up crash reporting (Firebase Crashlytics) from Day 1. Accept that v1.0 will have bugs. Have a "known issues" page ready. Users forgive bugs in a free app if you fix them fast.

### Elephant 3: "Group ranking might not be the killer feature we think it is"

The entire growth thesis rests on "people will invite friends to compete on dhikr consistency." But prayer is deeply personal for many Muslims. Some may find leaderboards for worship uncomfortable or even inappropriate ("turning ibadah into a game"). **The conversation to have**: Make groups OPTIONAL and never the default. Solo mode must be a complete, satisfying experience on its own. If groups don't take off, the app still works as the best solo dhikr tracker. Track the ratio: if <20% of users create/join groups after 30 days, the group thesis needs rethinking.

---

## Go/No-Go Checklist

### Before App Store submission (Week 6):

- [ ] Deep link flow tested end-to-end: WhatsApp → App Store → Install → Auto-join group (iOS + Android)
- [ ] Prayer times verified against Muslim Pro for 5 cities: Dubai, Riyadh, Jeddah, London, New York (within 1 min)
- [ ] App Review Notes prepared explaining 5 daily prayer notifications
- [ ] Prayer notifications default OFF, user opts-in
- [ ] Dhikr counter haptic feedback feels satisfying on iPhone 12+ and recent Android devices
- [ ] Leaderboard ranks by consistency, not volume
- [ ] Streak includes 1 "mercy day" freeze per week
- [ ] Crash reporting (Firebase Crashlytics) integrated
- [ ] "Join Public Group" option available for new users
- [ ] Arabic App Store listing (title + description + keywords) ready
- [ ] WhatsApp invite message template in both English and Arabic
- [ ] Privacy policy and Terms of Service pages live
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
