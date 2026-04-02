import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final int target;

  const CounterDisplay({
    super.key,
    required this.count,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main count
        Text(
          '$count',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            color: ZikrColors.ink,
          ),
        ),
        // Target info
        Text(
          '/ $target',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: ZikrColors.inkMuted,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
