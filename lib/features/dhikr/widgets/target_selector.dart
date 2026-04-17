import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/skin.dart';

class TargetSelector extends ConsumerWidget {
  final int currentTarget;
  final ValueChanged<int> onTargetChanged;

  const TargetSelector({
    super.key,
    required this.currentTarget,
    required this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);

    return PopupMenuButton<int>(
      onSelected: onTargetChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: skin.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Target: $currentTarget',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: skin.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: skin.primary,
              size: 20,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        ...AppConstants.presetTargets.map(
          (target) => PopupMenuItem(
            value: target,
            child: Row(
              children: [
                if (target == currentTarget)
                  Icon(Icons.check_rounded, size: 18, color: skin.primary)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text('$target'),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: -1, // Signal for custom
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 18, color: skin.inkMuted),
              const SizedBox(width: 8),
              const Text('Custom...'),
            ],
          ),
          onTap: () {
            // Show custom target dialog after menu closes
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                _showCustomTargetDialog(context);
              }
            });
          },
        ),
      ],
    );
  }

  void _showCustomTargetDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom target'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                onTargetChanged(value);
              }
              Navigator.pop(context);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }
}
