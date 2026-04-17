import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../../core/skin.dart';

class DhikrTypeSelector extends ConsumerWidget {
  final List<DhikrType> types;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DhikrTypeSelector({
    super.key,
    required this.types,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skin = ref.watch(skinProvider);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? skin.primary : skin.surfaceCard,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? skin.primary : skin.divider,
                ),
              ),
              child: Center(
                child: Text(
                  type.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : skin.ink,
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
