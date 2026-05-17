# Zikr Vibe — App Store & Google Play Listing Copy

**Last updated**: 2026-05-18
**Status**: v1.0.12 production-ready (Google Play); iOS deferred (Apple Dev not purchased)

> **fastlane sync (2026-05-18)**: `android/fastlane/metadata/android/en-US/` has been brought in line with this doc — `title.txt`, `short_description.txt`, `full_description.txt`, and `changelogs/14.txt` (v1.0.12+14) are all current. Yun may paste these straight into Play Console listing edit.
>
> **Privacy + Terms LIVE**: `https://app.zikrvibe.com/privacy` (V2.0, eff. 2026-05-02) + `https://app.zikrvibe.com/terms` (eff. 2026-05-18, pending push of `web/terms/index.html`).

---

## v1.0.12 Production Release Notes (2026-05-18)

Source-of-truth: `android/fastlane/metadata/android/en-US/changelogs/14.txt`.

```
v1.0.12 — Hardening release

• Dhikr Circles: rebuilt invite + join flow, fixed a crash when joining via invite code
• Sign-in: gracefully recovers if your session expires while the app is open
• Prayer time reminders: more reliable scheduling for the times you opted in to
• Streak: persists through restarts, short network outages, and battery deaths
• Stability fixes across counter, calendar, and Circles screens
• Updated Privacy Policy and added Terms of Service

Privacy by design: your dhikr counts stay on your device.
```

What changed under the hood since the v1.0 listing copy below was written:
- `create_circle` RPC now `SECURITY DEFINER` (6 migrations applied to Supabase `ocxnevqgjiyhwdfpskfc`)
- Zombie auth session recovery (gracefully retries on expired session instead of locking the user out)
- Prayer notification scheduler hardened (no duplicate fires, no missed fires on cold start)
- Streak persistence with mercy day logic
- 8 hand-tuned skins (Dusty Rose, Mosque Green, Gold, ...)
- Deep link intent filter scaffolding for `https://zikrvibe.com/join/<code>` (autoVerify pending Shopify `assetlinks.json` deploy — out of scope for v1.0.12 listing)

---

## iOS App Store

### App Name (30 char max)
```
Zikr Vibe: Tasbih Counter
```

### Subtitle (30 char max)
```
Smart Dhikr & Azkar Tracker
```

### Keywords (100 char max, comma-separated)
```
tasbeeh,prayer beads,islamic,dua,subhanallah,zikr ring,muslim,daily,free,counter,digital,reminder
```

### Promotional Text (170 char, can be updated without new build)
```
Count your dhikr with peace of mind. No ads. No data selling. Just you and your remembrance of Allah. Feel the vibration at 33, 66, 99.
```

### Description (4000 char max)

```
Your dhikr deserves better than ads and distractions.

Zikr Vibe is a distraction-free tasbih counter built for Muslims who want to remember Allah without their phone pulling them away. No ads. No data collection. No haram content interrupting your worship. Just tap, count, and feel.

DISTRACTION-FREE COUNTING
Open the app, tap the screen, close your eyes. The large tap zone fills your screen — no tiny buttons, no cluttered UI. Each tap gives gentle haptic feedback. When you reach 33, 66, or 99, a strong vibration tells you without looking. Count your tasbih the way it should be: between you and Allah.

33-BEAD PROGRESS
A ring of 33 dots shows exactly where you are in your current round of tasbih. SubhanAllah, Alhamdulillah, Allahu Akbar — see and feel your progress through each set.

YOUR DATA STAYS WITH YOU
Your dhikr counts are stored on your device. We do not sell your data. We do not share it with advertisers. We do not track your prayer habits. After the Muslim Pro data scandal, we believe privacy is not a feature — it is a right.

STREAK TRACKING
See your current streak of consecutive days with dhikr. 7 days, 30 days, 100 days — every day you show up is a day you remembered. No scores. No grades. Just consistency, on your terms.

DHIKR CIRCLE (Companionship, Not Competition)
Create a private dhikr circle with family or close friends. See who did their dhikr today — not how much, just that they showed up. No leaderboards. No rankings. Ibadah is between you and Allah. Your circle is there to walk beside you, not compete with you.

Send a gentle "thinking of you" tap to remind someone in your circle. Invite friends through WhatsApp with one tap.

PRAYER TIMES & QIBLA
Accurate prayer times for your location with multiple calculation methods (Umm al-Qura, ISNA, Muslim World League, and more). Push notifications before each prayer. Built-in Qibla compass pointing toward Mecca.

MULTIPLE DHIKR TYPES
Pre-loaded with SubhanAllah, Alhamdulillah, Allahu Akbar, and La ilaha illallah — with Arabic text and transliteration. Add your own custom dhikr with a personal target. Each type tracks independently.

FLEXIBLE TARGETS
Set your target to 33, 66, 99, 100, or any number up to 9,999. The app vibrates when you hit your goal. Your counts never disappear — they persist through app restarts, phone reboots, and battery deaths.

DAILY LOG & CALENDAR
See your dhikr history on a calendar. Green days mean you remembered. Track your weekly and monthly totals. Your progress, visible at a glance.

BUILT FOR MUSLIMS, BY SOUL VIBE
Zikr Vibe is made by Soul Vibe Technology. We build tools that present your data without judgment. No scores. No AI telling you what to do. Your heartbeat, your dhikr, your decision.

Free. No ads. No in-app purchases (v1.0). No subscriptions. No tricks.

Count your dhikr. That is all.
```

### What's New (for updates)
```
Assalamu Alaikum! Welcome to Zikr Vibe.
- Distraction-free dhikr counter with haptic milestones at 33/66/99
- 33-bead progress visualization
- Dhikr circles: see who showed up today (no rankings)
- Prayer times with notifications
- Qibla compass
- Streak tracking
- Multiple dhikr types with custom targets
- All data stored locally on your device
```

---

## Google Play Store

### App Title (30 char max)
```
Zikr Vibe: Tasbih Counter
```

### Short Description (80 char max)
```
Smart dhikr & tasbeeh counter with vibration. Track azkar, duas & daily zikr.
```

### Full Description (4000 char max)

```
Your dhikr deserves better than ads and distractions.

Zikr Vibe is a distraction-free tasbih counter built for Muslims who want to remember Allah without their phone getting in the way. No ads. No data selling. No haram content. Just tap, count, and feel.

DISTRACTION-FREE TASBIH COUNTER
Open the app, tap the screen, close your eyes. A large tap zone fills your screen. Each tap gives gentle haptic feedback. At 33, 66, and 99, a strong vibration tells you the milestone — no need to look. Count your dhikr the way it should be: between you and Allah.

33-BEAD DIGITAL TASBIH
A ring of 33 dots shows where you are in your current round. SubhanAllah, Alhamdulillah, Allahu Akbar — see and feel your way through each set of prayer beads, digitally.

YOUR DATA STAYS ON YOUR DEVICE
We do not sell your data. We do not share with advertisers. We do not track your worship. Your dhikr counts are stored locally. Privacy is not a feature. It is a right.

STREAK TRACKING & DAILY LOG
Track consecutive days of dhikr. See your history on a calendar — green means you remembered. Weekly and monthly summaries keep you motivated. No judgment, just data.

DHIKR CIRCLE — COMPANIONSHIP, NOT COMPETITION
Create a private circle with family or close friends. See who did dhikr today — a simple check mark, not a number. No leaderboards. No rankings. Your ibadah is between you and Allah. Your circle walks beside you, not against you.

Invite friends through WhatsApp. Send a gentle reminder tap when someone in your circle has not counted yet today.

PRAYER TIMES & NOTIFICATIONS
Accurate salah times for Fajr, Dhuhr, Asr, Maghrib, and Isha based on your location. Supports Umm al-Qura, ISNA, Muslim World League, and other calculation methods. Set push notifications before each prayer.

QIBLA COMPASS
Find the direction of Mecca from anywhere. Uses your device compass and GPS for accurate Qibla direction.

MULTIPLE DHIKR & AZKAR TYPES
Pre-loaded: SubhanAllah, Alhamdulillah, Allahu Akbar, La ilaha illallah — with Arabic script and English transliteration. Add custom dhikr with your own target. Each tracks independently.

FLEXIBLE TARGETS — FREE COUNTING
Set 33, 66, 99, 100, or any number up to 9,999. Or count freely without a target. Your counts persist through restarts and reboots — no more losing progress.

ISLAMIC DESIGN
Warm gold and emerald palette. Geometric patterns. Calligraphy accents. Designed to feel like a place of worship, not a tech product.

WHAT MAKES ZIKR VIBE DIFFERENT
- Zero ads — no haram ads during your dhikr, ever
- Zero data selling — your prayer data is yours alone
- Haptic milestones — feel 33/66/99 without looking
- Companionship circles — presence, not competition
- Persistent counts — never lose your dhikr to a crash or battery death
- One-hand operation — count while walking, sitting, or lying down

Free. No ads. No subscriptions. No tricks.

Made by Soul Vibe Technology.
Count your dhikr. That is all.
```

---

## App Store Screenshots — Text Overlays (5 screens)

### Screen 1: Counter
**Headline**: Count Your Dhikr in Peace
**Subline**: No ads. No distractions. Just you and Allah.

### Screen 2: Haptic Milestones
**Headline**: Feel the Count
**Subline**: Strong vibration at 33, 66, 99. Close your eyes and count.

### Screen 3: Dhikr Circle
**Headline**: Walk Together, Not Against Each Other
**Subline**: See who showed up today. No rankings. Just companionship.

### Screen 4: Privacy
**Headline**: Your Data Stays With You
**Subline**: We don't sell your data. We don't show ads. Period.

### Screen 5: Streak & Calendar
**Headline**: Every Day You Remember
**Subline**: Track your streak. See your history. No judgment.

---

## App Store Category & Tags

**Primary Category**: Lifestyle
**Secondary Category**: Health & Fitness (for Apple) or Social (for Google Play)

**Google Play Tags**: islamic, prayer, tasbih, dhikr, muslim, quran, azkar, ramadan

---

## Seasonal ASO Updates

### During Ramadan (update 2 weeks before)
- **Title**: `Zikr Vibe: Ramadan Tasbih` (swap back after Ramadan)
- **Promotional Text**: "Ramadan Mubarak! Track your dhikr this holy month. Set daily goals and keep your streak through all 30 days."
- **Screenshots**: Add Ramadan-themed overlay to Screen 1

### During Hajj Season
- **Promotional Text**: "Hajj Mubarak! Keep counting your dhikr on the journey. Works offline."

---

## Localization Priority

| Language | Market | Priority |
|----------|--------|----------|
| English | Global, US/UK/Canada, Gulf educated | v1.0 |
| Arabic | Saudi, UAE, Egypt, North Africa | v1.1 |
| Bahasa Indonesia | Indonesia (242M Muslims) | v1.1 |
| Turkish | Turkey (84M Muslims) | v1.2 |
| Urdu | Pakistan (240M Muslims) | v1.2 |
| Bahasa Malay | Malaysia | v1.2 |
