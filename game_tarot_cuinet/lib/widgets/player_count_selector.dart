import 'package:flutter/material.dart';

/// A widget that allows the selection of the number of players.
/// [count] → Number of players represented by this selector.
/// [selectedCount] → Currently selected number of players.
/// [onSelected] → Callback function when this count is selected.
class PlayerCountSelector extends StatelessWidget {
  final int count;
  final int selectedCount;
  final ValueChanged<int> onSelected;

  const PlayerCountSelector({
    super.key,
    required this.count,
    required this.selectedCount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedCount == count;

    return GestureDetector(
      onTap: () => onSelected(count),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
            width: 2,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              '$count joueurs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
