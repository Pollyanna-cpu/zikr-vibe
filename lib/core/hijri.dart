/// Tabular (arithmetic) Islamic calendar — the standard civil algorithm
/// (30-year cycle, 11 leap years, epoch 16 July 622 CE = JD 1948440).
///
/// Actual Hijri dates depend on local moonsighting / the Saudi Umm al-Qura
/// calendar and can differ by up to ~2 days from any arithmetic calendar
/// (verified against Aladhan gToH on 2026-08-06); `adjustment` (user
/// setting, -3..+3 days) absorbs that. Never present this as authoritative
/// for Ramadan/Eid starts.
class HijriDate {
  final int year;
  final int month; // 1-12
  final int day;

  const HijriDate(this.year, this.month, this.day);

  static const List<String> monthNames = [
    'Muharram',
    'Safar',
    "Rabi' al-Awwal",
    "Rabi' al-Thani",
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    "Dhu al-Qi'dah",
    'Dhu al-Hijjah',
  ];

  String get monthName => monthNames[month - 1];

  /// e.g. "22 Safar 1448 AH"
  String format() => '$day $monthName $year AH';

  static HijriDate fromGregorian(DateTime date, {int adjustment = 0}) {
    final adjusted = date.add(Duration(days: adjustment));
    final jd = _julianDay(adjusted.year, adjusted.month, adjusted.day);

    // Kuwaiti/civil tabular algorithm.
    int l = jd - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;

    return HijriDate(year, month, day);
  }

  /// Gregorian date → Julian Day Number (valid for all Gregorian dates).
  static int _julianDay(int year, int month, int day) {
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }
}
