import 'package:flutter/material.dart';
import '../main.dart';
import 'custom_button.dart';

Future<int?> numberInputDialog(BuildContext context, max) async {
  final context = navigatorKey.currentContext;
  if (context == null) return null;
  final TextEditingController controller = TextEditingController();

  return await showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Annonce ton nombre de plis'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Entre un nombre entre 0 et $max',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          Center(
            child: CustomButton(
              text: 'Valider',
              onPressed: () {
                final text = controller.text.trim();
                final value = int.tryParse(text);
                if (value != null && value >= 0 && value <= max) {
                  Navigator.pop(context, value);
                }
              },
            ),
          ),
        ],
      );
    },
  );
}