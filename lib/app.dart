import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'core/skin.dart';
import 'l10n/app_localizations.dart';

class ZikrVibeApp extends ConsumerWidget {
  const ZikrVibeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final skin = ref.watch(skinProvider);

    return MaterialApp.router(
      title: 'Zikr Vibe',
      debugShowCheckedModeBanner: false,
      theme: ZikrTheme.lightFrom(skin),
      darkTheme: ZikrTheme.darkFrom(skin),
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
