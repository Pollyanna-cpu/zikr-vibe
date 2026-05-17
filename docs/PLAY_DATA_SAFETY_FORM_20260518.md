# Google Play Data Safety Form — Zikr Vibe (v1.0.12)

**Purpose**: Paste-ready answers for the Data Safety section in Play Console
(`Policy and programs → App content → Data safety → Manage`).

**Derived from**: LIVE privacy policy at `https://app.zikrvibe.com/privacy` (effective 2026-05-02).
**Package**: `com.zikrvibe.app` · **Compiled**: 2026-05-18

---

## Section 1 — Data collection and security (summary screen)

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **Yes** |
| Is all of the user data collected by your app encrypted in transit? | **Yes** (TLS / HTTPS to Supabase + Aladhan API) |
| Do you provide a way for users to request that their data be deleted? | **Yes** — in-app `Settings → Delete Account` + email `soulvibeai@gmail.com` |
| Does your app comply with Google Play Families Policy? | **No** (app is not directed at children under 13; not enrolled in Designed for Families) |

---

## Section 2 — Data types (per category)

For each "Yes" data type below, Play Console asks 5 sub-questions:
1. Is this data collected? (Yes / No)
2. Is this data shared? (Yes / No → with whom)
3. Is collection required or optional?
4. Why is this data collected? (one or more of: App functionality, Analytics, Developer communications, Advertising or marketing, Fraud prevention, Compliance, Account management, Personalization)
5. Is this data processed ephemerally?

### 2.1 Personal info

| Data type | Collected? | Shared? | Required/Optional | Purposes |
|---|---|---|---|---|
| Name (display name) | **Yes** | **Yes** — shown to members of any Circle you join | Optional | App functionality |
| Email address | **Yes** | No | Required (for account) | App functionality, Account management |
| User ID (Supabase UUID) | **Yes** | No | Required (for account) | App functionality |
| Address | No | — | — | — |
| Phone number | No | — | — | — |
| Race and ethnicity | No | — | — | — |
| Political or religious beliefs | **No** — see note below | — | — | — |
| Sexual orientation | No | — | — | — |
| Other info | No | — | — | — |

> **Note on "religious beliefs"**: Play Console treats this category as data that *explicitly identifies* a user's faith. Zikr Vibe is categorically a Muslim-market app, but we do not ask users to declare a faith and we do not store one. Account creation does not include a religion field. **Answer "No".**

### 2.2 Financial info — all **No**
v1.0.12 has no in-app purchases and no payment processing.

### 2.3 Health and fitness — all **No**
Counts, streaks, and presence are app activity, not health data.

### 2.4 Messages — all **No**
Circle interactions are limited to a daily presence mark and an optional "thinking of you" nudge. We do not collect SMS, email content, or in-app chat history.

### 2.5 Photos and videos — all **No**
Avatar URL is optional and stored as a URL only; we do not upload or host photos or videos.

### 2.6 Audio files — all **No**
### 2.7 Files and docs — all **No**
### 2.8 Calendar — all **No**
Prayer reminders are scheduled via OS local notifications; we do not read or write your device calendar.

### 2.9 Contacts — all **No**
Circle invites use a random invite code, never your contact list.

### 2.10 App activity

| Data type | Collected? | Shared? | Required/Optional | Purposes |
|---|---|---|---|---|
| App interactions (daily presence ✓/·) | **Yes** | **Yes** — with members of any Circle you join | Optional (only if you join a Circle) | App functionality |
| In-app search history | No | — | — | — |
| Installed apps | No | — | — | — |
| Other user-generated content (Circle name, description, custom dhikr labels) | **Yes** | **Yes** — with Circle members | Optional | App functionality |
| Other actions | No | — | — | — |

### 2.11 Web browsing — all **No**

### 2.12 App info and performance

| Data type | Collected? | Shared? | Required/Optional | Purposes |
|---|---|---|---|---|
| Crash logs | No | — | — | — |
| Diagnostics | No | — | — | — |
| Other app performance data | No | — | — | — |

> **⚠ Yun verify before submit**: confirm v1.0.12 build has **no** Crashlytics / Sentry / Firebase Crash Reporting. If any was added later, flip to Yes + purposes "App functionality" + "Analytics".

### 2.13 Device or other IDs

| Data type | Collected? | Shared? | Required/Optional | Purposes |
|---|---|---|---|---|
| Device or other IDs | No | — | — | — |

> **⚠ Yun verify before submit**: confirm we do **not** collect Android Advertising ID (AAID) or any persistent device identifier. v1.0.12 has no ads SDK so this should be clean "No".

### 2.14 Location

| Data type | Collected? | Shared? | Required/Optional | Purposes |
|---|---|---|---|---|
| Approximate location | **Yes** — sent to Aladhan Prayer Times API as lat/long | **Yes** — shared with Aladhan (third-party API) for prayer-time calculation | Optional (only if you enable prayer times) | App functionality |
| Precise location | No | — | — | — |

> **Important**: Play Console considers location "collected" if it leaves the device. v1.0.12 sends approximate lat/long to Aladhan for prayer-time calculation. Privacy policy §6 documents this. Tell users in-app what they're enabling.

---

## Section 3 — Security practices

| Question | Answer |
|---|---|
| Is all user data encrypted in transit? | **Yes** (TLS for Supabase + Aladhan API) |
| Do you provide a way for users to request their data be deleted? | **Yes** (`Settings → Delete Account` + email request) |
| Do you commit to follow the Play Families Policy? | **No** (app is 13+) |
| Have you been independently validated against MASA tier? | **No** (not pursued for v1.0.12) |

---

## Section 4 — Account deletion (required free-text)

```
You can delete your account and all server-side data at any time:

1. In the app: open Settings → Delete Account → Confirm.
2. By email: send a request to soulvibeai@gmail.com from your registered
   email address. We will delete your account within 30 days.

Deletion removes: profile, daily presence history, streaks, notification
preferences, and Circle memberships. On-device dhikr counts are removed when
you uninstall the app or clear browser storage.
```

---

## Section 5 — Privacy policy URL

```
https://app.zikrvibe.com/privacy
```

---

## Yun click sequence (Play Console UI)

1. Play Console → `com.zikrvibe.app` → **Policy and programs → App content → Data safety → Manage**
2. Step through "Data collection and security" → answer per Section 1
3. Step through each data type → answer per Section 2
4. Security practices → per Section 3
5. Save draft → Review → **Submit**
6. On the Production release page, confirm "Data safety form completed"

---

## Pre-submit verification checklist

- [ ] Confirm §2.12 (crash logs) reflects v1.0.12 (no Crashlytics, no Sentry, no Firebase Crash Reporting)
- [ ] Confirm §2.13 (device IDs) — no AAID / no Firebase Installations ID / no other persistent ID logged
- [ ] Confirm §2.14 (location) — Aladhan API call is the only outgoing lat/long
- [ ] Privacy policy URL `https://app.zikrvibe.com/privacy` returns HTTP 200 (✓ verified 2026-05-18)
- [ ] Terms URL `https://app.zikrvibe.com/terms` returns HTTP 200 (pending — `web/terms/index.html` committed, awaiting `push`)
