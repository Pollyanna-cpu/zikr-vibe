import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/skin.dart';
import '../data/adhkar.dart';

class AdhkarScreen extends ConsumerWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Adhkar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in kAdhkar) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                section.title.toUpperCase(),
                style: TextStyle(
                  color: skin.inkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            for (final dhikr in section.items) _DhikrCard(dhikr: dhikr),
          ],
          const SizedBox(height: 8),
          Text(
            'Short foundational remembrances. Counts follow the narrations cited on each card.',
            textAlign: TextAlign.center,
            style: TextStyle(color: skin.inkMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DhikrCard extends ConsumerWidget {
  final Dhikr dhikr;

  const _DhikrCard({required this.dhikr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: skin.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: skin.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bundled NotoNaskhArabic: the web engine can't fetch fallback
          // fonts (CSP blocks gstatic), so without this Arabic renders as
          // tofu boxes on app.zikrvibe.com.
          SizedBox(
            width: double.infinity,
            child: Text(
              dhikr.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 22,
                height: 1.9,
                color: skin.ink,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dhikr.transliteration,
            style: TextStyle(
              color: skin.ink,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dhikr.translation,
            style: TextStyle(color: skin.inkMuted, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: skin.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  dhikr.count,
                  style: TextStyle(
                    color: skin.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                dhikr.source,
                style: TextStyle(color: skin.inkMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
