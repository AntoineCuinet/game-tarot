import 'package:flutter/material.dart';
import '../main.dart';
import './custom_button.dart';

/// Affiche une boîte de dialogue d'information personnalisable.
/// [title] → Titre de la popup.
/// [message] → Contenu principal du message.
/// [buttonText] → (Optionnel) texte du bouton, par défaut "OK".
Future<void> gameInputDialog({
  required String title,
  required String message,
  String buttonText = 'OK',
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      );
    },
  );
}
