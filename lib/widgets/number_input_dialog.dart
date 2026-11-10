import 'package:flutter/material.dart';

import '../main.dart';
import 'custom_button.dart';

/// Displays a dialog allowing the user to input a number within a specified range.
/// [max] → Maximum allowable number (inclusive).
/// [forbiddenValue] → (Optional) A number that cannot be chosen (used for the last player choice).
Future<int?> numberInputDialog(BuildContext context, int max, {int? forbiddenValue}) async {
  final context = navigatorKey.currentContext;
  if (context == null) return null;
  final TextEditingController controller = TextEditingController();
  String? errorMessage;

  return await showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Annonce ton nombre de plis'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (forbiddenValue != null)
                  Text(
                    '(Tu ne peux pas annoncer : $forbiddenValue)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Entre un nombre entre 0 et $max',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
              ],
            ),
            actions: [
              Center(
                child: CustomButton(
                  text: 'Valider',
                  onPressed: () {
                    final text = controller.text.trim();
                    final value = int.tryParse(text);
                    if (value == null || value < 0 || value > max || value == forbiddenValue) {
                      setState(() {
                        errorMessage = 'Valeur invalide.';
                      });
                      return;
                    }

                    Navigator.pop(context, value);
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  );
}
