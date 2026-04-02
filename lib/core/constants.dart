class AppConstants {
  // Supabase — fill after creating project
  static const String supabaseUrl = 'https://nooeuncofhtzutbhquot.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vb2V1bmNvZmh0enV0YmhxdW90Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUxMzE2NzAsImV4cCI6MjA5MDcwNzY3MH0.PHwErzKHm_GNQyPYYAQYC3sFYt_wK7dX_Kmd7Xm9SE0';

  // Default dhikr types
  static const List<DhikrType> defaultDhikrTypes = [
    DhikrType(
      id: 'subhanallah',
      name: 'SubhanAllah',
      arabic: 'سبحان الله',
      meaning: 'Glory be to Allah',
      defaultTarget: 33,
    ),
    DhikrType(
      id: 'alhamdulillah',
      name: 'Alhamdulillah',
      arabic: 'الحمد لله',
      meaning: 'Praise be to Allah',
      defaultTarget: 33,
    ),
    DhikrType(
      id: 'allahuakbar',
      name: 'Allahu Akbar',
      arabic: 'الله أكبر',
      meaning: 'Allah is the Greatest',
      defaultTarget: 33,
    ),
    DhikrType(
      id: 'lailahaillallah',
      name: 'La ilaha illallah',
      arabic: 'لا إله إلا الله',
      meaning: 'There is no god but Allah',
      defaultTarget: 100,
    ),
  ];

  // Preset targets
  static const List<int> presetTargets = [33, 66, 99, 100];

  // Group limits
  static const int maxGroupMembers = 50;
  static const int maxGroupsPerUser = 5;

  // Streak
  static const int mercyDaysPerWeek = 1;
}

class DhikrType {
  final String id;
  final String name;
  final String arabic;
  final String meaning;
  final int defaultTarget;

  const DhikrType({
    required this.id,
    required this.name,
    required this.arabic,
    required this.meaning,
    required this.defaultTarget,
  });
}
