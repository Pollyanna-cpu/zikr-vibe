import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants.dart';
import 'core/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('dhikr_sessions');
  await Hive.openBox('settings');

  // Initialize Supabase
  if (AppConstants.supabaseUrl != 'YOUR_SUPABASE_URL') {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  // Initialize notifications
  await NotificationService.init();

  runApp(
    const ProviderScope(
      child: ZikrVibeApp(),
    ),
  );
}
