import 'package:flutter/material.dart';

import '../main.dart';
import '../models/card_model.dart';

/// Displays a dialog allowing the user to choose a card from their hand.
/// [hand] → List of cards in the player's hand.
Future<CardModel?> cardChoiceInputDialog(BuildContext context, List<CardModel> hand) async {
  final context = navigatorKey.currentContext;
  if (context == null) return null;

  return await showDialog<CardModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Choisis une carte à jouer'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: hand.map((card) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, card),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                        card.isVisible ? card.assetPath : 'assets/CaJ-TaroTv1-Dos.png',
                        width: 60,
                        height: 100
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
