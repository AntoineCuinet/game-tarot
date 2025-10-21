import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../main.dart';

Future<CardModel?> cardChoiceInputDialog(BuildContext context, List<CardModel> hand) async {
  final context = navigatorKey.currentContext;
  if (context == null) return null;

  return await showDialog<CardModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
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
                    Image.asset(card.assetPath, width: 60, height: 100),
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
