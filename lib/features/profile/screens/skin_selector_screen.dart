import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/skin.dart';
import '../../iap/iap_service.dart';

class SkinSelectorScreen extends ConsumerWidget {
  const SkinSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(skinProvider);
    final ownedNotifier = ref.watch(ownedSkinsProvider.notifier);
    // Watching the set rebuilds this screen instantly when IAP unlocks a skin.
    ref.watch(ownedSkinsProvider);

    // Surface purchase outcomes — without this, a canceled or failed Google
    // Play checkout silently returned the user to a still-locked skin.
    ref.listen<IapEvent?>(iapEventProvider, (_, event) {
      if (event == null) return;
      final message = switch (event.kind) {
        'purchased' =>
          '${ZikrSkins.byId(event.skinId!).name} unlocked & applied ✓',
        'canceled' => 'Purchase canceled.',
        _ => 'Purchase failed. Please try again.',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: ZikrSkins.all.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final skin = ZikrSkins.all[index];
          final isSelected = skin.id == current.id;
          final owned = ownedNotifier.isOwned(skin);

          return GestureDetector(
            onTap: () async {
              if (owned) {
                ref.read(skinProvider.notifier).select(skin);
              } else {
                // Paid skin — launch Google Play IAP purchase flow
                final iap = ref.read(iapServiceProvider);
                final ok = await iap.buySkin(skin.id);
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Purchase unavailable. Try again or restore from Profile.',
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? skin.primary : skin.divider,
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: skin.primary.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Column(
                  children: [
                    // Live preview area — shows pattern + counter sample
                    Container(
                      height: 140,
                      decoration: BoxDecoration(color: skin.surface),
                      child: Stack(
                        children: [
                          // Pattern preview
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _SkinPatternPreview(skin),
                            ),
                          ),
                          // Counter number preview
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'SubhanAllah',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: skin.inkSoft,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '33',
                                  style: GoogleFonts.inter(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w700,
                                    color: skin.accent,
                                    height: 1,
                                    letterSpacing: -2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Dot preview
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    11,
                                    (i) => Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: skin.primary
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Info bar
                    Container(
                      color: skin.surfaceCard,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          // Primary + accent swatch
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [skin.primary, skin.accent],
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  skin.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${skin.nameAr}  ·  ${skin.description}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded,
                                color: skin.primary, size: 24)
                          else if (!owned)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: skin.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                // Full precision — toStringAsFixed(0) showed
                                // "$2" for a $1.99 skin, overstating the price
                                // vs the actual Play checkout amount.
                                '\$${skin.priceUsd.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: skin.primary,
                                ),
                              ),
                            )
                          else
                            Icon(Icons.radio_button_unchecked_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.15),
                                size: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Draws the appropriate pattern for each skin in the preview card.
class _SkinPatternPreview extends CustomPainter {
  final ZikrSkin skin;
  _SkinPatternPreview(this.skin);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = skin.primary.withValues(alpha: skin.patternOpacity * 2.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    if (skin.patternStyle == 'arabesque') {
      _paintArabesque(canvas, size, paint);
    } else {
      _paintOctagram(canvas, size, paint);
    }
  }

  void _paintOctagram(Canvas canvas, Size size, Paint paint) {
    const spacing = 50.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawStar8(canvas, Offset(x, y), 12, paint);
      }
    }
  }

  void _drawStar8(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = (i * pi / 4) - pi / 2;
      final ox = c.dx + r * cos(a);
      final oy = c.dy + r * sin(a);
      final ia = a + pi / 8;
      final ix = c.dx + r * 0.4 * cos(ia);
      final iy = c.dy + r * 0.4 * sin(ia);
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _paintArabesque(Canvas canvas, Size size, Paint paint) {
    final accentPaint = Paint()
      ..color = skin.accent.withValues(alpha: skin.patternOpacity * 1.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const spacing = 46.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        final ox = (y ~/ spacing).isOdd ? x + spacing * 0.5 : x;
        _drawRosette(canvas, Offset(ox, y), 14, paint);
        _drawRosette(canvas, Offset(ox, y), 8, accentPaint);
      }
    }
  }

  void _drawRosette(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    const petals = 6;
    for (int i = 0; i < petals; i++) {
      final a = (i * 2 * pi / petals) - pi / 2;
      final na = ((i + 1) * 2 * pi / petals) - pi / 2;
      final tx = c.dx + r * cos(a);
      final ty = c.dy + r * sin(a);
      final ntx = c.dx + r * cos(na);
      final nty = c.dy + r * sin(na);
      final ma = (a + na) / 2;
      final cx2 = c.dx + r * 0.55 * cos(ma);
      final cy2 = c.dy + r * 0.55 * sin(ma);

      if (i == 0) path.moveTo(tx, ty);
      path.quadraticBezierTo(cx2, cy2, ntx, nty);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SkinPatternPreview old) =>
      old.skin.id != skin.id;
}
