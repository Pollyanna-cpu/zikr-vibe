import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/skin.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/dhikr_provider.dart';
import '../models/counter_group.dart';
import '../../streak/providers/streak_provider.dart';
import '../../streak/screens/streak_screen.dart';

final dhikrWakelockEnabledProvider = Provider<bool>((ref) => true);

class DhikrScreen extends ConsumerStatefulWidget {
  const DhikrScreen({super.key});

  @override
  ConsumerState<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends ConsumerState<DhikrScreen>
    with TickerProviderStateMixin {
  // Tap scale animation
  late AnimationController _tapController;
  late Animation<double> _tapScale;

  // Ripple animation
  late AnimationController _rippleController;
  late Animation<double> _rippleSize;
  late Animation<double> _rippleOpacity;

  // Count change animation
  late AnimationController _countController;

  @override
  void initState() {
    super.initState();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rippleSize = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    _rippleOpacity = Tween<double>(begin: 0.15, end: 0.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _countController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Keep screen awake during dhikr
    if (!kIsWeb && ref.read(dhikrWakelockEnabledProvider)) {
      WakelockPlus.enable();
    }
  }

  @override
  void dispose() {
    _tapController.dispose();
    _rippleController.dispose();
    _countController.dispose();
    if (!kIsWeb && ref.read(dhikrWakelockEnabledProvider)) {
      WakelockPlus.disable();
    }
    super.dispose();
  }

  void _onTap() {
    ref.read(dhikrProvider.notifier).tap();
    ref.read(streakProvider.notifier).markTodayActive();

    // Play animations
    _tapController.forward().then((_) => _tapController.reverse());
    _rippleController.forward(from: 0.0);
    _countController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final dhikr = ref.watch(dhikrProvider);
    final skin = ref.watch(skinProvider);
    final group = dhikr.active;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: skin.surface,
      body: GestureDetector(
        onTap: _onTap,
        onLongPress: () => _showResetSheet(context, ref, group.name),
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! < -200) {
            final next = (dhikr.activeIndex + 1) % dhikr.groups.length;
            ref.read(dhikrProvider.notifier).switchGroup(next);
          } else if (details.primaryVelocity! > 200) {
            final prev = (dhikr.activeIndex - 1 + dhikr.groups.length) %
                dhikr.groups.length;
            ref.read(dhikrProvider.notifier).switchGroup(prev);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Subtle geometric background pattern
            Positioned.fill(child: _GeometricBackground(skin: skin)),

            // Ripple effect
            AnimatedBuilder(
              animation: _rippleController,
              builder: (context, child) {
                if (!_rippleController.isAnimating) return const SizedBox();
                return Center(
                  child: Container(
                    width: 300 * _rippleSize.value,
                    height: 300 * _rippleSize.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          skin.tapGlow.withValues(alpha: _rippleOpacity.value),
                    ),
                  ),
                );
              },
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Minimal group pills
                  _GroupPills(
                    groups: dhikr.groups,
                    activeIndex: dhikr.activeIndex,
                    onTap: (i) =>
                        ref.read(dhikrProvider.notifier).switchGroup(i),
                    onAdd: dhikr.groups.length < 5
                        ? () => _showAddGroupSheet(context, ref)
                        : null,
                  ),

                  // Counter area — perfectly centered
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _tapController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _tapScale.value,
                          child: child,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Group name — elegant
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              group.name,
                              key: ValueKey(group.id),
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: skin.inkSoft,
                                letterSpacing: 1.5,
                              ).copyWith(
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // THE NUMBER — hero element
                          // Gold glow at 33/66/99/100 milestones
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              '${group.count}',
                              key: ValueKey(group.count),
                              style: GoogleFonts.inter(
                                fontSize: 120,
                                fontWeight: FontWeight.w700,
                                color: ref
                                        .read(dhikrProvider.notifier)
                                        .isAtMilestone
                                    ? skin.accent
                                    : skin.ink,
                                height: 1,
                                letterSpacing: -4,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Subtle progress dots (visual rhythm)
                          if (!group.isAtMax)
                            _ProgressDots(count: group.count, skin: skin),
                        ],
                      ),
                    ),
                  ),

                  // Bottom — streak + daily total
                  GestureDetector(
                    onTap: () {
                      // Navigate to streak screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StreakScreen()),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          // Streak badge (tappable)
                          Consumer(builder: (context, ref, _) {
                            final streak = ref.watch(streakProvider);
                            if (streak.currentStreak > 0) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: skin.primarySoft,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🔥',
                                        style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 6),
                                    Text(
                                      AppLocalizations.of(context)
                                          .dayStreak(streak.currentStreak),
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: skin.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                          const SizedBox(height: 6),
                          if (dhikr.dailyTotal > 0)
                            Text(
                              AppLocalizations.of(context)
                                  .todayTotal(dhikr.dailyTotal),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: skin.inkMuted,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            group.isAtMax
                                ? AppLocalizations.of(context).alhamdulillah
                                : AppLocalizations.of(context).gestureHint,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: skin.inkMuted.withValues(alpha: 0.5),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetSheet(BuildContext context, WidgetRef ref, String name) {
    final skin = ref.read(skinProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: skin.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: skin.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context).resetPrompt(name),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: skin.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).counterResetNote,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: skin.inkSoft,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: skin.divider),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).actionCancel,
                        style: GoogleFonts.inter(
                          color: skin.inkSoft,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        ref.read(dhikrProvider.notifier).resetActive();
                        Navigator.pop(ctx);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: skin.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).actionReset,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGroupSheet(BuildContext context, WidgetRef ref) {
    final skin = ref.read(skinProvider);
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: skin.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: skin.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).newCounterTitle,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: skin.ink,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              maxLength: 30,
              style: GoogleFonts.inter(fontSize: 16),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).counterHint,
                hintStyle: GoogleFonts.inter(color: skin.inkMuted),
                filled: true,
                fillColor: skin.surface,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    ref.read(dhikrProvider.notifier).addGroup(name);
                  }
                  Navigator.pop(ctx);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: skin.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).actionAdd,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal group selector pills
class _GroupPills extends ConsumerWidget {
  final List<CounterGroup> groups;
  final int activeIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onAdd;

  const _GroupPills({
    required this.groups,
    required this.activeIndex,
    required this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: groups.length + (onAdd != null ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == groups.length) {
            return GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: skin.divider, width: 1),
                ),
                child: Icon(Icons.add, size: 16, color: skin.inkMuted),
              ),
            );
          }

          final isActive = index == activeIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? skin.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive ? skin.primary : skin.divider,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  groups[index].name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive ? Colors.white : skin.inkSoft,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Subtle progress dots — visual rhythm for counting
class _ProgressDots extends StatelessWidget {
  final int count;
  final ZikrSkin skin;

  const _ProgressDots({required this.count, required this.skin});

  @override
  Widget build(BuildContext context) {
    final dotsInCycle = count % 33;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        33,
        (i) => Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < dotsInCycle
                ? skin.primary.withValues(alpha: 0.6)
                : skin.divider,
          ),
        ),
      ),
    );
  }
}

/// Subtle Islamic geometric background — colors from current skin
class _GeometricBackground extends StatelessWidget {
  final ZikrSkin skin;
  const _GeometricBackground({required this.skin});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _IslamicPatternPainter(skin));
  }
}

class _IslamicPatternPainter extends CustomPainter {
  final ZikrSkin skin;
  _IslamicPatternPainter(this.skin);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = skin.primary.withValues(alpha: skin.patternOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    if (skin.patternStyle == 'arabesque') {
      _paintArabesque(canvas, size, paint);
    } else {
      _paintOctagram(canvas, size, paint);
    }
  }

  // --- Octagram: 8-pointed star (mosque ceilings) ---
  void _paintOctagram(Canvas canvas, Size size, Paint paint) {
    const spacing = 80.0;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        _drawOctagramStar(canvas, Offset(x, y), spacing * 0.3, paint);
      }
    }
  }

  void _drawOctagramStar(
      Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4) - pi / 2;
      final outerX = center.dx + radius * cos(angle);
      final outerY = center.dy + radius * sin(angle);
      final innerAngle = angle + pi / 8;
      final innerX = center.dx + radius * 0.4 * cos(innerAngle);
      final innerY = center.dy + radius * 0.4 * sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // --- Arabesque: interlocking petal curves (Ottoman tiles, rose gardens) ---
  void _paintArabesque(Canvas canvas, Size size, Paint paint) {
    // Second layer: accent-colored petals, lower opacity
    final accentPaint = Paint()
      ..color = skin.accent.withValues(alpha: skin.patternOpacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const spacing = 72.0;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        // Offset every other row for a woven feel
        final ox = (y ~/ spacing).isOdd ? x + spacing * 0.5 : x;
        _drawRosette(canvas, Offset(ox, y), spacing * 0.32, paint);
        _drawRosette(canvas, Offset(ox, y), spacing * 0.18, accentPaint);
      }
    }
  }

  /// A 6-petal rosette using quadratic Bézier curves.
  void _drawRosette(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const petals = 6;
    for (int i = 0; i < petals; i++) {
      final angle = (i * 2 * pi / petals) - pi / 2;
      final nextAngle = ((i + 1) * 2 * pi / petals) - pi / 2;

      final tipX = center.dx + radius * cos(angle);
      final tipY = center.dy + radius * sin(angle);
      final nextTipX = center.dx + radius * cos(nextAngle);
      final nextTipY = center.dy + radius * sin(nextAngle);

      // Control point pushes outward for a rounded petal
      final midAngle = (angle + nextAngle) / 2;
      final cpX = center.dx + radius * 0.55 * cos(midAngle);
      final cpY = center.dy + radius * 0.55 * sin(midAngle);

      if (i == 0) {
        path.moveTo(tipX, tipY);
      }
      path.quadraticBezierTo(cpX, cpY, nextTipX, nextTipY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _IslamicPatternPainter old) =>
      old.skin.id != skin.id;
}
