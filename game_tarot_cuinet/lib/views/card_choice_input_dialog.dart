import 'package:flutter/material.dart';
import '../models/card_model.dart';

Future<CardModel?> cardChoiceInputDialog(BuildContext context, List<CardModel> hand) async {
  return await showDialog<CardModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Choisis une carte à jouer"),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hand.map((card) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, card),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(card.assetPath, width: 60, height: 100),
                    Text(
                      card.name,
                      style: const TextStyle(fontSize: 12),
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
