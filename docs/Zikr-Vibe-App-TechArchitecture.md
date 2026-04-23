# Tech Architecture: Zikr Vibe App

**Date**: 2026-04-02 (canonical) — updated 2026-04-24 for privacy-first pivot
**Confidential — Internal Use Only**

**Canonical reference**: See `Zikr-Vibe-App-PRD.md` §9 Privacy Architecture for the data-on-server contract.

## Key Architectural Promise (non-negotiable)

**No dhikr data ever touches our server.** Counts, dhikr types, session timing, frequency — all stay on device. Server stores only circle membership + binary daily presence. This is enforced by schema (not by policy) so accidentally adding a ranking feature is physically impossible.

---

## Stack Decision

### Flutter (recommended) vs React Native

| Criteria | Flutter | React Native | Winner |
|----------|---------|-------------|--------|
| Single codebase iOS + Android | Yes | Yes | Tie |
| UI performance (haptic + animation) | Excellent (Skia engine) | Good (bridge overhead) | **Flutter** |
| Claude's ability to generate | Both doable | Both doable | Tie |
| Supabase SDK | supabase_flutter (official) | supabase-js (official) | Tie |
| Prayer time library | adhan-dart (port of adhan) | adhan (npm, original) | Tie |
| Compass/sensor access | sensors_plus (well maintained) | react-native-sensors | Tie |
| Deep linking | app_links (Universal Links / App Links) | react-native-app-links | Tie — Firebase Dynamic Links deprecated Aug 2025 |
| App size | ~15MB base | ~25MB base | **Flutter** |
| Hot reload speed | Fast | Fast | Tie |
| Islamic text rendering (Arabic RTL) | Built-in RTL + custom fonts | Needs config | **Flutter** |
| Apple Watch (future P2) | Limited | Limited | Tie |

**Decision: Flutter**
- Better haptic/animation control (critical for dhikr counter feel)
- Smaller app size
- Native RTL support (Arabic v1.1)
- Dart is strongly typed → fewer runtime bugs with Claude-generated code

---

## Architecture Diagram

```
┌──────────────────────────────────────────────────────┐
│                    FLUTTER APP                         │
│                                                        │
│  ┌────────────┐ ┌────────────┐ ┌──────────────────┐  │
│  │   Riverpod │ │   GoRouter │ │   Local Storage  │  │
│  │   (state)  │ │   (nav)    │ │   (Hive)         │  │
│  │            │ │            │ │   ALL dhikr data │  │
│  └─────┬──────┘ └─────┬──────┘ └────────┬─────────┘  │
│        │              │                  │             │
│  ┌─────┴──────────────┴──────────────────┴─────────┐  │
│  │              Feature Modules                     │  │
│  │  ┌──────┐ ┌───────┐ ┌───────┐ ┌──────┐ ┌──────┐│  │
│  │  │Dhikr │ │Circles│ │Prayer │ │Streak│ │Auth  ││  │
│  │  │Count │ │Present│ │Times  │ │Mercy │ │Profile││ │
│  │  └──────┘ └───────┘ └───────┘ └──────┘ └──────┘│  │
│  └─────────────────────┬───────────────────────────┘  │
│                        │                               │
│  ┌─────────────────────┴───────────────────────────┐  │
│  │              Platform Services                   │  │
│  │  Haptics │ Compass │ GPS │ LocalNotifs │ Share  │  │
│  └─────────────────────────────────────────────────┘  │
└────────────────────────┬─────────────────────────────┘
                         │ HTTPS / WebSocket
                         │ (CIRCLES ONLY — no dhikr data)
┌────────────────────────┴─────────────────────────────┐
│                    SUPABASE (minimal)                  │
│                                                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────────┐  │
│  │   Auth   │ │ Realtime │ │   Edge Functions     │  │
│  │ Apple/   │ │ (presence│ │ - circle invite gen  │  │
│  │ Google/  │ │  sync    │ │                      │  │
│  │ Email    │ │  only)   │ │                      │  │
│  │ optional │ │          │ │                      │  │
│  └──────────┘ └──────────┘ └──────────────────────┘  │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │              PostgreSQL                           │  │
│  │  users │ circles │ circle_members │              │  │
│  │  daily_presence (boolean only — NO count column) │  │
│  │                                                   │  │
│  │  NO dhikr_sessions. NO streaks. NO milestones.   │  │
│  │  ALL that data lives ONLY in Hive on device.     │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
                         │
┌────────────────────────┴─────────────────────────────┐
│               EXTERNAL SERVICES (minimal)              │
│                                                        │
│  app_links (deep linking, self-hosted redirect)       │
│  zikrvibe.com/join/CIRCLE_CODE                        │
│                                                        │
│  flutter_local_notifications (prayer times, local)    │
│  Firebase Cloud Messaging (only for gentle nudges)    │
│                                                        │
│  Firebase Crashlytics (opt-in only, anonymous)        │
│                                                        │
│  ❌ NO Firebase Analytics (privacy promise)            │
│  ❌ NO Firebase Dynamic Links (deprecated)             │
└────────────────────────────────────────────────────────┘
```

---

## Database Schema

### Server-side (Supabase PostgreSQL) — MINIMAL

```sql
-- Users (only basics, only if signed in)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  auth_provider TEXT, -- 'apple', 'google', 'email'
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Note: NO timezone, NO prayer_method, NO lifetime stats.
-- Those are device-local preferences, not user-identifying data.

-- Circles (formerly "groups")
CREATE TABLE circles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  admin_id UUID REFERENCES users(id),
  invite_code TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Circle Members
CREATE TABLE circle_members (
  circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (circle_id, user_id)
);

-- Daily Presence — THE ONLY dhikr-adjacent data on server
-- Records that a user did ANY dhikr on a given date. No count, no type, no time.
CREATE TABLE daily_presence (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  PRIMARY KEY (user_id, circle_id, date)
);
-- No count column. No dhikr_type column. No time column. Only presence.
-- Schema-level guarantee that a future developer cannot accidentally add ranking.

-- Invites (for expiry tracking + anti-abuse)
CREATE TABLE invites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id UUID REFERENCES circles(id),
  invited_by UUID REFERENCES users(id),
  expires_at TIMESTAMPTZ NOT NULL,
  used_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Row-Level Security (RLS)**:

```sql
-- Users see circles they belong to
CREATE POLICY "Members see own circles" ON circles
  FOR SELECT USING (
    auth.uid() IN (SELECT user_id FROM circle_members WHERE circle_id = circles.id)
  );

-- Users insert only their own presence
CREATE POLICY "Insert own presence" ON daily_presence
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users see presence only for their own circles
CREATE POLICY "See circle presence" ON daily_presence
  FOR SELECT USING (
    circle_id IN (SELECT circle_id FROM circle_members WHERE user_id = auth.uid())
  );
```

### Device-local (Hive) — ALL dhikr data lives here

```dart
// Hive boxes (Dart pseudocode)

@HiveType(typeId: 0)
class DhikrSession {
  @HiveField(0) int id;
  @HiveField(1) String dhikrType;       // SubhanAllah, etc.
  @HiveField(2) int count;
  @HiveField(3) int target;
  @HiveField(4) DateTime startedAt;
  @HiveField(5) DateTime endedAt;
  @HiveField(6) String date;            // local date string for streak calc
}

@HiveType(typeId: 1)
class DhikrCounterGroup {
  @HiveField(0) String id;
  @HiveField(1) String name;            // "SubhanAllah", custom name, etc.
  @HiveField(2) int currentCount;
  @HiveField(3) int? target;
  @HiveField(4) int lifetimeCount;      // local only, never synced
}

@HiveType(typeId: 2)
class StreakState {
  @HiveField(0) int currentStreak;
  @HiveField(1) int longestStreak;
  @HiveField(2) DateTime? lastActiveDate;
  @HiveField(3) int mercyDaysUsedThisWeek;
  @HiveField(4) DateTime? mercyWeekStart;
}

@HiveType(typeId: 3)
class NotificationPrefs {
  @HiveField(0) bool fajrEnabled = false;
  @HiveField(1) bool dhuhrEnabled = false;
  @HiveField(2) bool asrEnabled = false;
  @HiveField(3) bool maghribEnabled = false;
  @HiveField(4) bool ishaEnabled = false;
  @HiveField(5) int offsetMinutes = 10;
  @HiveField(6) String prayerMethod = 'UmmAlQura';
}

@HiveType(typeId: 4)
class UserPrefs {
  @HiveField(0) String? timezone;
  @HiveField(1) String locale = 'en';  // 'en' or 'ar'
  @HiveField(2) bool crashReportingConsent = false;
  @HiveField(3) String themeSkin = 'Rosewater';
}
```

**Write strategy**: write-on-every-tap (sub-millisecond, ACID-safe via Hive transactions). Never debounce — every tap must persist immediately to survive force-quit / battery death.

**Sync to server**: once per day, when user opens app. Flutter calls `INSERT INTO daily_presence (user_id, circle_id, date) VALUES (...) ON CONFLICT DO NOTHING;` for each circle. Sends only the boolean fact that dhikr happened today. Never sends count.

---

## Key Flutter Packages

| Package | Purpose | Notes |
|---------|---------|-------|
| `supabase_flutter` | Backend (Auth, circles, daily_presence only) | Minimal usage |
| `flutter_riverpod` | State management | |
| `go_router` | Navigation (with deep link handling) | |
| `hive_flutter` | **Primary local storage** for ALL dhikr data | Crash-safe, offline-first. Future: consider ObjectBox in v2 (Hive unmaintained ~4yr) |
| `adhan_dart` | Prayer time calculation (12 methods, Qibla bearing included) | Fully offline |
| `flutter_qiblah` | Qibla compass | Uses adhan_dart bearing + device compass |
| `flutter_compass` | Low-level compass sensor | |
| `geolocator` | GPS location (local only, never sent to server) | |
| `flutter_local_notifications` | **Prayer reminders — local, zero server dependency** | Schedule 5 notifications per day |
| `app_links` | Deep linking (Universal Links / App Links) — **replaces Firebase Dynamic Links** (deprecated Aug 2025) | Self-hosted redirect `zikrvibe.com/join/CODE` |
| `firebase_messaging` | Remote push (only for optional gentle circle nudges) | Not used for prayer times |
| `firebase_crashlytics` | Crash reporting — **opt-in only, anonymous** | Explicit consent dialog at first launch |
| `share_plus` | WhatsApp/SMS sharing for circle invites | |
| `haptic_feedback` + built-in `HapticFeedback` | Light tap per count + strong at 33/66/99 milestones | |
| `wakelock_plus` | Keep screen on during active counting | Disable when done |
| `intl` | Date/time formatting, RTL support | |
| `flutter_svg` | Islamic geometric pattern assets | |
| `google_fonts` | Amiri, Noto Sans Arabic | |
| `sign_in_with_apple` | Apple auth (required by App Store if auth offered) | Optional — app works without login |
| `google_sign_in` | Google auth | Optional |

### Explicitly REMOVED from deps (from v1 architecture)

| Package | Reason removed |
|---------|----------------|
| `firebase_dynamic_links` | Service deprecated Aug 2025. Replaced by `app_links` + self-hosted redirect |
| `firebase_analytics` | Privacy promise — no analytics on prayer content, no usage tracking |
| `adhan` (original JS port) | Replaced by `adhan_dart` (native Dart, better maintained for Flutter) |

---

## Supabase Free Tier Limits & Plan

| Resource | Free Tier | Our Estimate (90 days, conservative 3K users) | Safe? |
|----------|-----------|----------------------|-------|
| Database | 500 MB | **~10 MB** (3K users × 1KB + circles + presence rows) | ✅ |
| Auth users | 50,000 MAU | 3,000 (optional login) | ✅ |
| Storage | 1 GB | ~30 MB (avatars only) | ✅ |
| Bandwidth | 2 GB/month | **~100 MB** (tiny — no dhikr data transfers) | ✅ |
| Edge Functions | 500K invocations/mo | ~10K (invite link gen) | ✅ |
| Realtime | 200 concurrent | Peak ~20 | ✅ |

**Verdict**: Free tier is sufficient well beyond first 90 days. Database is **dramatically smaller** than v1 architecture because no `dhikr_sessions` / `streaks` / `milestones` tables on server.

Upgrade trigger: >20K MAU or any resource hits 80%. Projected upgrade: Month 9-12 → Pro ($25/mo).

---

## Firebase Usage (Minimal)

| Service | Our Use | Notes |
|---------|---------|-------|
| Cloud Messaging | Optional gentle circle nudges only | Prayer times use `flutter_local_notifications` instead |
| Crashlytics | Opt-in anonymous crash reporting | Explicit consent at first launch |
| ~~Dynamic Links~~ | **Not used** — deprecated Aug 2025 | Replaced by `app_links` |
| ~~Analytics~~ | **Not used** — privacy promise | No usage tracking, no funnel analytics on prayer content |

**Cost**: $0 (Crashlytics + FCM both unlimited on free tier).

---

## Offline Strategy

| Feature | Online Required? | Offline Behavior |
|---------|-----------------|-----------------|
| Dhikr counter | **No** | Counts persist locally in Hive. Never sync (privacy promise). |
| Streak display | **No** | Calculated entirely locally from Hive data |
| Prayer times | **No** | `adhan_dart` computes locally from cached GPS coordinates (7+ days ahead) |
| Qibla compass | **No** | Local compass + `adhan_dart` Qibla bearing |
| Circle presence board | Yes (for sync) | Shows last cached state + "Updating..." — degrades gracefully |
| Circle invite links | Yes | Queue for when online |
| Auth | Yes (for login) | Local-only mode available without account |

**Core dhikr experience works 100% offline forever.** Circles need connectivity for presence sync, but the local counter keeps working.

---

## Security & Privacy

| Concern | Approach |
|---------|---------|
| User data on server | **Minimal**: email + display name + avatar (only if signed in). **Never**: dhikr counts, dhikr types, session timing, location, IP logging |
| Dhikr data | **Never on server.** Hive local only. This is the core privacy promise, enforced by schema (no `count` column exists on any server table) |
| Encryption | Supabase default: TLS in transit, AES-256 at rest |
| Auth | Supabase Auth with Apple/Google/Email. **Optional — app works without login** |
| Row-level security | Supabase RLS: users can only read/write their own data. Circle presence visible to other members of the same circle only |
| Prayer location | GPS used only for local `adhan_dart` calculation. Not stored on server. Cached in Hive on device only |
| GDPR/Privacy | Privacy policy required. Account deletion must be supported (Apple requirement) — deletes server user + circle memberships + daily_presence rows. Local Hive data deleted via "Reset App" in settings |
| No tracking IDs | **No advertising ID collection anywhere.** No Firebase Analytics SDK in dependencies |
| Crash reporting | Firebase Crashlytics with **explicit opt-in consent dialog at first launch**. Anonymous only. Default: off. |
| Ads | **Zero ad SDKs ever** — not AdMob, not Facebook Audience Network, not anything. Verified at code review + CI lint |

---

## Cost Summary (First 6 Months)

| Item | Monthly Cost | Notes |
|------|-------------|-------|
| Supabase | $0 (free tier) → $25 (Pro at ~20K MAU) | Months 1-3 free, months 4-6 $25/mo |
| Firebase | $0 | All services used are free tier |
| Apple Developer | $99/year ($8.25/mo) | Already have |
| Google Play Developer | $25 one-time | One-time |
| Domain (zikrvibe.com) | Already owned | $0 |
| **Total Month 1-3** | **~$8/mo** | |
| **Total Month 4-6** | **~$33/mo** | |

**Total 6-month cost: ~$125.** Essentially free to operate.

---

## Project Structure

```
zikr_vibe/
├── lib/
│   ├── main.dart
│   ├── app.dart                    # Theme, router, providers
│   ├── core/
│   │   ├── supabase_client.dart    # Supabase init
│   │   ├── theme.dart              # Islamic color palette
│   │   ├── constants.dart          # Dhikr types, targets
│   │   └── extensions.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/            # Login, onboarding
│   │   │   ├── providers/          # Auth state
│   │   │   └── models/             # User model
│   │   ├── dhikr/
│   │   │   ├── screens/            # Counter screen
│   │   │   ├── providers/          # Count state, session
│   │   │   ├── models/             # DhikrSession, DhikrType
│   │   │   └── widgets/            # Counter display, progress ring
│   │   ├── circles/
│   │   │   ├── screens/            # Circle list, Companionship Board
│   │   │   ├── providers/          # Circle state, presence sync
│   │   │   ├── models/             # Circle, CircleMember, DailyPresence
│   │   │   └── widgets/            # Presence row (✓/·), invite card
│   │   ├── prayer/
│   │   │   ├── screens/            # Prayer times, Qibla
│   │   │   ├── providers/          # Prayer time calc
│   │   │   └── widgets/            # Compass, prayer card
│   │   ├── streak/
│   │   │   ├── screens/            # Calendar, history
│   │   │   ├── providers/          # Streak calc
│   │   │   └── widgets/            # Calendar view, streak badge
│   │   └── profile/
│   │       ├── screens/            # Profile, settings
│   │       └── providers/
│   └── shared/
│       ├── widgets/                # Common widgets
│       └── utils/                  # Formatters, helpers
├── assets/
│   ├── icons/                      # App icon, tab icons
│   ├── patterns/                   # Islamic geometric SVGs
│   ├── fonts/                      # Amiri, Arabic fonts
│   └── sounds/                     # Tap sounds (optional)
├── supabase/
│   ├── migrations/                 # SQL schema
│   └── functions/                  # Edge functions
├── pubspec.yaml
└── README.md
```

---

*"The architecture should be as simple as the prayer it serves."*
