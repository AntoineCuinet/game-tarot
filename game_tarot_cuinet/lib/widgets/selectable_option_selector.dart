import 'package:flutter/material.dart';

/// Selection widget that can select any type of value.
/// [value] → The value represented by this widget.
/// [selectedValue] → The currently selected value.
/// [label] → The text displayed.
/// [onSelected] → Callback when this option is selected.
class SelectableOption<T> extends StatelessWidget {
  final T value;
  final T selectedValue;
  final String label;
  final ValueChanged<T> onSelected;

  const SelectableOption({
    super.key,
    required this.value,
    required this.selectedValue,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () => onSelected(value),
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
              label,
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
