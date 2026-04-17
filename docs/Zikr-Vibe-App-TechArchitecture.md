# Tech Architecture: Zikr Vibe App

**Date**: 2026-04-02
**Confidential — Internal Use Only**

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
| Deep linking | firebase_dynamic_links | react-native-firebase | Tie |
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
│  │   (state)  │ │   (nav)    │ │   (Hive/Isar)    │  │
│  └─────┬──────┘ └─────┬──────┘ └────────┬─────────┘  │
│        │              │                  │             │
│  ┌─────┴──────────────┴──────────────────┴─────────┐  │
│  │              Feature Modules                     │  │
│  │  ┌──────┐ ┌──────┐ ┌───────┐ ┌──────┐ ┌──────┐│  │
│  │  │Dhikr │ │Groups│ │Prayer │ │Streak│ │Auth  ││  │
│  │  │Count │ │Rank  │ │Times  │ │Track │ │Profile││ │
│  │  └──────┘ └──────┘ └───────┘ └──────┘ └──────┘│  │
│  └─────────────────────┬───────────────────────────┘  │
│                        │                               │
│  ┌─────────────────────┴───────────────────────────┐  │
│  │              Platform Services                   │  │
│  │  Haptics │ Compass │ GPS │ Notifications │ Share │  │
│  └─────────────────────────────────────────────────┘  │
└────────────────────────┬─────────────────────────────┘
                         │ HTTPS / WebSocket
┌────────────────────────┴─────────────────────────────┐
│                    SUPABASE                            │
│                                                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────────┐  │
│  │   Auth   │ │ Realtime │ │   Edge Functions     │  │
│  │ Apple/   │ │ (leader- │ │ - invite link gen    │  │
│  │ Google/  │ │  board   │ │ - milestone card gen │  │
│  │ Email    │ │  updates)│ │ - prayer time calc   │  │
│  └──────────┘ └──────────┘ └──────────────────────┘  │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │              PostgreSQL                           │  │
│  │  users │ groups │ memberships │ dhikr_sessions   │  │
│  │  streaks │ invites │ milestones                  │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
                         │
┌────────────────────────┴─────────────────────────────┐
│               EXTERNAL SERVICES                        │
│                                                        │
│  Firebase Dynamic Links  │  Firebase Cloud Messaging  │
│  (deep linking)          │  (push notifications)      │
│                          │                             │
│  Firebase Crashlytics    │  Firebase Analytics         │
│  (crash reporting)       │  (usage tracking)           │
└────────────────────────────────────────────────────────┘
```

---

## Database Schema (Supabase PostgreSQL)

```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  auth_provider TEXT, -- 'apple', 'google', 'email'
  timezone TEXT DEFAULT 'Asia/Dubai',
  prayer_method TEXT DEFAULT 'UmmAlQura',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dhikr Sessions
CREATE TABLE dhikr_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  dhikr_type TEXT NOT NULL, -- 'SubhanAllah', 'Alhamdulillah', etc.
  count INTEGER NOT NULL,
  target INTEGER,
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ NOT NULL,
  date DATE NOT NULL, -- local date for streak calc
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_sessions_user_date ON dhikr_sessions(user_id, date);

-- Streaks (materialized, updated by trigger)
CREATE TABLE streaks (
  user_id UUID PRIMARY KEY REFERENCES users(id),
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_active_date DATE,
  mercy_days_used INTEGER DEFAULT 0, -- resets weekly
  mercy_week_start DATE,
  lifetime_dhikr BIGINT DEFAULT 0
);

-- Groups
CREATE TABLE groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  admin_id UUID REFERENCES users(id),
  invite_code TEXT UNIQUE NOT NULL,
  member_count INTEGER DEFAULT 1,
  total_dhikr BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Group Memberships
CREATE TABLE memberships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id),
  user_id UUID REFERENCES users(id),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(group_id, user_id)
);

-- Invites
CREATE TABLE invites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES groups(id),
  invited_by UUID REFERENCES users(id),
  invite_link TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Leaderboard View (materialized, refreshed every 5 min)
CREATE MATERIALIZED VIEW group_leaderboard AS
SELECT
  m.group_id,
  m.user_id,
  u.display_name,
  u.avatar_url,
  COUNT(DISTINCT ds.date) AS active_days,
  SUM(ds.count) AS total_dhikr,
  s.current_streak
FROM memberships m
JOIN users u ON u.id = m.user_id
LEFT JOIN dhikr_sessions ds ON ds.user_id = m.user_id
  AND ds.date >= date_trunc('week', CURRENT_DATE)
LEFT JOIN streaks s ON s.user_id = m.user_id
GROUP BY m.group_id, m.user_id, u.display_name, u.avatar_url, s.current_streak;

-- Milestones
CREATE TABLE milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  type TEXT NOT NULL, -- 'streak_7', 'streak_30', 'dhikr_10000', etc.
  achieved_at TIMESTAMPTZ DEFAULT NOW(),
  shared BOOLEAN DEFAULT FALSE
);

-- Notification Preferences
CREATE TABLE notification_prefs (
  user_id UUID PRIMARY KEY REFERENCES users(id),
  fajr_enabled BOOLEAN DEFAULT FALSE,
  dhuhr_enabled BOOLEAN DEFAULT FALSE,
  asr_enabled BOOLEAN DEFAULT FALSE,
  maghrib_enabled BOOLEAN DEFAULT FALSE,
  isha_enabled BOOLEAN DEFAULT FALSE,
  offset_minutes INTEGER DEFAULT 10
);
```

---

## Key Flutter Packages

| Package | Purpose | Version |
|---------|---------|---------|
| `supabase_flutter` | Backend (Auth, DB, Realtime) | latest |
| `flutter_riverpod` | State management | latest |
| `go_router` | Navigation | latest |
| `hive_flutter` | Local storage (offline dhikr) | latest |
| `adhan` | Prayer time calculation | latest (or port) |
| `flutter_compass` | Qibla compass | latest |
| `geolocator` | GPS location | latest |
| `flutter_local_notifications` | Prayer reminders | latest |
| `firebase_dynamic_links` | Deep linking for invites | latest |
| `firebase_messaging` | Push notifications | latest |
| `firebase_crashlytics` | Crash reporting | latest |
| `firebase_analytics` | Usage analytics | latest |
| `share_plus` | WhatsApp/SMS sharing | latest |
| `haptic_feedback` | Custom haptics (or HapticFeedback API) | built-in |
| `intl` | Date/time formatting, RTL support | latest |
| `flutter_svg` | Islamic geometric pattern assets | latest |
| `google_fonts` | Amiri, Noto Sans Arabic | latest |
| `sign_in_with_apple` | Apple auth | latest |
| `google_sign_in` | Google auth | latest |

---

## Supabase Free Tier Limits & Plan

| Resource | Free Tier | Our Estimate (90 days) | Safe? |
|----------|-----------|----------------------|-------|
| Database | 500 MB | ~50 MB (10K users × 5KB) | ✅ |
| Auth users | 50,000 MAU | 10,000 | ✅ |
| Storage | 1 GB | ~100 MB (avatars) | ✅ |
| Bandwidth | 2 GB/month | ~500 MB | ✅ |
| Edge Functions | 500K invocations/mo | ~50K | ✅ |
| Realtime | 200 concurrent | Peak ~50 | ✅ |

**Verdict: Free tier is sufficient for first 90 days. Upgrade to Pro ($25/mo) at ~20K MAU.**

---

## Firebase Usage (Free Tier)

| Service | Free Tier | Our Use |
|---------|-----------|---------|
| Dynamic Links | Unlimited | Invite links |
| Cloud Messaging | Unlimited | Prayer notifications |
| Crashlytics | Unlimited | Crash reporting |
| Analytics | Unlimited | Usage tracking |

**All free. No cost.**

---

## Offline Strategy

| Feature | Online Required? | Offline Behavior |
|---------|-----------------|-----------------|
| Dhikr counter | No | Counts locally (Hive), syncs later |
| Streak display | No | Calculated locally |
| Prayer times | No | Cached for current location (7 days ahead) |
| Qibla compass | No | Local compass + cached coordinates |
| Groups/Leaderboard | Yes | Shows last cached state + "Updating..." |
| Invite links | Yes | Queue for when online |

**Core dhikr experience works 100% offline. Social features need connectivity.**

---

## Security & Privacy

| Concern | Approach |
|---------|---------|
| User data | Minimal collection: email, display name, dhikr counts. No phone number required |
| Encryption | Supabase default: TLS in transit, AES-256 at rest |
| Auth | Supabase Auth with Apple/Google/Email. No custom auth |
| Row-level security | Supabase RLS: users can only read/write their own data. Group data visible to members only |
| Prayer location | GPS used only for prayer time calc. Not stored on server. Cached locally only |
| GDPR/Privacy | Privacy policy required. Account deletion must be supported (Apple requirement) |
| No tracking IDs | No advertising ID collection. Firebase Analytics in anonymous mode |

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
│   │   ├── groups/
│   │   │   ├── screens/            # Group list, leaderboard
│   │   │   ├── providers/          # Group state, rankings
│   │   │   ├── models/             # Group, Membership
│   │   │   └── widgets/            # Leaderboard row, invite card
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
