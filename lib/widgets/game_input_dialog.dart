import 'package:flutter/material.dart';

import '../main.dart';
import 'custom_button.dart';

/// Displays a customizable information dialog.
/// [title] → Title of the popup.
/// [message] → Main content of the message.
/// [buttonText] → (Optional) text of the button, default is "OK".
/// [onConfirm] → (Optional) Callback function when the button is pressed.
Future<void> gameInputDialog({
  required String title,
  required String message,
  String buttonText = 'OK',
  VoidCallback? onConfirm,
}) async {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(title),
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: CustomButton(
              text: buttonText,
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) onConfirm();
              },
            ),
          ),
        ],
      );
    },
  );
}
