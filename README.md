# Zikr Vibe

Count your dhikr. Nothing else watches.

## Setup

### 1. Install Flutter
```bash
brew install --cask flutter
flutter doctor
```

### 2. Create Supabase Project
1. Go to https://supabase.com/dashboard
2. Create new project named "zikr-vibe"
3. Copy the **Project URL** and **anon key**
4. Paste into `lib/core/constants.dart`
5. Run the SQL from `supabase/migrations/001_initial_schema.sql` in the SQL Editor

### 3. Run
```bash
cd ~/Desktop/zikr_vibe
flutter pub get
flutter run
```

## Stack
- Flutter 3.x (Dart)
- Supabase (Auth, PostgreSQL, Realtime)
- Riverpod (state management)
- GoRouter (navigation)
- Hive (local storage)
- WakelockPlus (screen awake during dhikr)

## Hook setup (one-time, per dev environment)

```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

Enables a pre-push reminder to write Notion Run entries after each push. See [CLAUDE.md](./CLAUDE.md) for the worklog protocol.
