import 'package:flutter/material.dart';

Future<int?> numberInputDialog(BuildContext context, {
int max = 5, // TODO: change this later
}) async {
  final TextEditingController controller = TextEditingController();

  return await showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Annonce ton nombre de plis"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Entre un nombre entre 0 et $max",
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              final value = int.tryParse(text);
              if (value != null && value >= 0 && value <= max) {
                Navigator.pop(context, value);
              }
            },
            child: const Text("Valider"),
          ),
        ],
      );
    },
  );
}