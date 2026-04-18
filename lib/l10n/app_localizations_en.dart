// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zikr Vibe';

  @override
  String get navDhikr => 'Dhikr';

  @override
  String get navGroups => 'Groups';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navProfile => 'Profile';

  @override
  String get navStreak => 'Streak';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionSet => 'Set';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionBack => 'Back';

  @override
  String get actionJoin => 'Join';

  @override
  String get actionCreate => '+ Create';

  @override
  String get actionCustom => 'Custom...';

  @override
  String get newCounterTitle => 'New counter';

  @override
  String get counterHint => 'La ilaha illallah';

  @override
  String resetPrompt(String name) {
    return 'Reset $name?';
  }

  @override
  String get counterResetNote => 'Counter will return to 0';

  @override
  String get gestureHint => 'tap · swipe · hold';

  @override
  String get alhamdulillah => 'Alhamdulillah';

  @override
  String dayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String todayTotal(int count) {
    return '$count today';
  }

  @override
  String get yourJourney => 'Your Journey';

  @override
  String get customTarget => 'Custom target';

  @override
  String get appearance => 'Appearance';

  @override
  String get dhikrCircles => 'Dhikr Circles';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get profileTitle => 'Profile';

  @override
  String errorPrayerTimes(String err) {
    return 'Could not load prayer times:\n$err';
  }

  @override
  String errorGeneric(String err) {
    return 'Error: $err';
  }

  @override
  String errorGoogleSignIn(String err) {
    return 'Google sign in failed: $err';
  }
}
