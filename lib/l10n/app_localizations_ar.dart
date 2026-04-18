// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ذكر فايب';

  @override
  String get navDhikr => 'ذِكر';

  @override
  String get navGroups => 'المجموعات';

  @override
  String get navPrayer => 'الصلاة';

  @override
  String get navProfile => 'الملف';

  @override
  String get navStreak => 'التتابع';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionReset => 'إعادة تعيين';

  @override
  String get actionSet => 'تعيين';

  @override
  String get actionSkip => 'تخطي';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionJoin => 'انضمام';

  @override
  String get actionCreate => '+ إنشاء';

  @override
  String get actionCustom => 'مخصص...';

  @override
  String get newCounterTitle => 'عداد جديد';

  @override
  String get counterHint => 'لا إله إلا الله';

  @override
  String resetPrompt(String name) {
    return 'إعادة تعيين $name؟';
  }

  @override
  String get counterResetNote => 'سيعود العداد إلى 0';

  @override
  String get gestureHint => 'انقر · اسحب · اضغط مطولاً';

  @override
  String get alhamdulillah => 'الحمد لله';

  @override
  String dayStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سلسلة $count يوم',
      one: 'سلسلة يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String todayTotal(int count) {
    return '$count اليوم';
  }

  @override
  String get yourJourney => 'رحلتك';

  @override
  String get customTarget => 'هدف مخصص';

  @override
  String get appearance => 'المظهر';

  @override
  String get dhikrCircles => 'حلقات الذكر';

  @override
  String get prayerTimes => 'أوقات الصلاة';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String errorPrayerTimes(String err) {
    return 'تعذر تحميل أوقات الصلاة:\n$err';
  }

  @override
  String errorGeneric(String err) {
    return 'خطأ: $err';
  }

  @override
  String errorGoogleSignIn(String err) {
    return 'فشل تسجيل الدخول بحساب Google: $err';
  }
}
