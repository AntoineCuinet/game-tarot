import 'package:flutter/material.dart';

import '../main.dart';
import 'custom_button.dart';

/// Displays a dialog allowing the user to choose the value of the Excuse card (0 or 22 points).
Future<int?> excuseValueInputDialog() async {
  final context = navigatorKey.currentContext;
  if (context == null) return null;

  int selectedValue = 0; // Default selection

  return await showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Choix de la valeur de l\'Excuse'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<int>(
                  title: Text(
                    '0 point',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  value: 0,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: Text(
                    '22 points',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  value: 22,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              Center(
                child: CustomButton(
                  text: 'Valider',
                  onPressed: () {
                    Navigator.pop(context, selectedValue);
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
