import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'core/skin.dart';
import 'features/iap/iap_service.dart';
import 'l10n/app_localizations.dart';

final startupIapEnabledProvider = Provider<bool>((ref) => true);

class ZikrVibeApp extends ConsumerStatefulWidget {
  const ZikrVibeApp({super.key});

  @override
  ConsumerState<ZikrVibeApp> createState() => _ZikrVibeAppState();
}

class _ZikrVibeAppState extends ConsumerState<ZikrVibeApp> {
  @override
  void initState() {
    super.initState();
    // Init Google Play IAP listener - restores past purchases automatically
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!ref.read(startupIapEnabledProvider)) return;
      try {
        final iap = ref.read(iapServiceProvider);
        await iap.init();
        // Auto-restore on app launch - silent, populates owned_skins
        await iap.restorePurchases();
      } catch (e) {
        debugPrint('[App] IAP startup skipped after error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      // Force English (LTR) until language picker shipped - overrides device locale.
      // Tester signal 5/7: mixed Arabic UI on non-Arabic device.
      locale: const Locale('en'),
    );
  }
}
