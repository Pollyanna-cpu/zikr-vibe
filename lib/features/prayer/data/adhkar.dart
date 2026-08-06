/// Foundational adhkar — short, universally known remembrances only.
/// Arabic is standard undiacritized script; translations are plain-English
/// renderings (no copyrighted translation text). Longer supplications
/// (Sayyid al-Istighfar, ayat recitations) intentionally excluded until a
/// license-verified dataset is integrated.
class Dhikr {
  final String arabic;
  final String transliteration;
  final String translation;
  final String count;
  final String source;

  const Dhikr({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.count,
    required this.source,
  });
}

class AdhkarSection {
  final String title;
  final List<Dhikr> items;

  const AdhkarSection(this.title, this.items);
}

const List<AdhkarSection> kAdhkar = [
  AdhkarSection('Morning & Evening', [
    Dhikr(
      arabic: 'رضيت بالله ربا وبالإسلام دينا وبمحمد نبيا',
      transliteration:
          'Raditu billahi rabban, wa bil-islami dinan, wa bi-Muhammadin nabiyya',
      translation:
          'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet.',
      count: '3× morning · 3× evening',
      source: 'Abu Dawud, Tirmidhi',
    ),
    Dhikr(
      arabic: 'اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك النشور',
      transliteration:
          'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur',
      translation:
          'O Allah, by You we enter the morning and by You the evening; by You we live and by You we die, and to You is the resurrection.',
      count: '1× morning',
      source: 'Tirmidhi',
    ),
    Dhikr(
      arabic:
          'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير',
      transliteration:
          'La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa \'ala kulli shay\'in qadir',
      translation:
          'None has the right to be worshipped but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things.',
      count: '10× or 100×',
      source: 'Bukhari, Muslim',
    ),
    Dhikr(
      arabic: 'سبحان الله وبحمده',
      transliteration: 'SubhanAllahi wa bihamdihi',
      translation: 'Glory be to Allah and His is the praise.',
      count: '100× daily',
      source: 'Bukhari, Muslim',
    ),
  ]),
  AdhkarSection('After Prayer', [
    Dhikr(
      arabic: 'سبحان الله',
      transliteration: 'SubhanAllah',
      translation: 'Glory be to Allah.',
      count: '33×',
      source: 'Bukhari, Muslim',
    ),
    Dhikr(
      arabic: 'الحمد لله',
      transliteration: 'Alhamdulillah',
      translation: 'All praise is for Allah.',
      count: '33×',
      source: 'Bukhari, Muslim',
    ),
    Dhikr(
      arabic: 'الله أكبر',
      transliteration: 'Allahu Akbar',
      translation: 'Allah is the Greatest.',
      count: '34×',
      source: 'Bukhari, Muslim',
    ),
  ]),
  AdhkarSection('Anytime', [
    Dhikr(
      arabic: 'سبحان الله وبحمده، سبحان الله العظيم',
      transliteration: 'SubhanAllahi wa bihamdihi, SubhanAllahil-\'Azim',
      translation:
          'Glory be to Allah and His is the praise; glory be to Allah, the Magnificent.',
      count: 'Often',
      source: 'Bukhari, Muslim',
    ),
    Dhikr(
      arabic: 'لا حول ولا قوة إلا بالله',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no power and no strength except with Allah.',
      count: 'Often',
      source: 'Bukhari, Muslim',
    ),
    Dhikr(
      arabic: 'أستغفر الله',
      transliteration: 'Astaghfirullah',
      translation: 'I seek the forgiveness of Allah.',
      count: '100× daily',
      source: 'Muslim',
    ),
    Dhikr(
      arabic: 'حسبنا الله ونعم الوكيل',
      transliteration: 'Hasbunallahu wa ni\'mal-wakil',
      translation:
          'Allah is sufficient for us, and He is the best disposer of affairs.',
      count: 'In difficulty',
      source: 'Quran 3:173',
    ),
    Dhikr(
      arabic: 'اللهم صل على محمد',
      transliteration: 'Allahumma salli \'ala Muhammad',
      translation: 'O Allah, send blessings upon Muhammad.',
      count: 'Often',
      source: 'Muslim',
    ),
  ]),
];
