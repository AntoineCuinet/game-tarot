import 'package:flutter/material.dart';

/// A customizable button widget with same global styling.
/// [text] → Text to display on the button.
/// [onPressed] → Callback function when the button is pressed.
/// [backgroundColor] → (Optional) Background color of the button.
/// [textColor] → (Optional) Text color of the button.
/// [borderRadius] → (Optional) Border radius of the button, default is 12.
/// [padding] → (Optional) Padding inside the button, default is symmetric vertical 15 and horizontal 24.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? colors.primary,
        foregroundColor: textColor ?? colors.onPrimary,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
