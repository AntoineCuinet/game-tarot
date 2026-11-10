import 'package:flutter/material.dart';

import '../models/player_model.dart';

/// Widget to build a player display with name, trick, hand and points remaining.
/// [player] → The player to display.
/// [rotationIndex] → Rotation index to rotate the player display (0: bottom, 1: left, 2: top, 3: right).
Widget buildPlayer(PlayerModel player, {int rotationIndex = 0}) {
  final String backOfCard = 'assets/CaJ-TaroTv1-Dos.png';

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row (
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            player.isDealer ? Icons.star : Icons.person,
            color: player.isDealer ? Colors.amber : Colors.grey,
            size: 30,
          ),
          Text(
            player.name,
            style: TextStyle(
              fontWeight:
              player.isDealer ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            '${player.wonTricks} / ${player.announcedTricks}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),

      RotatedBox(
        quarterTurns: rotationIndex,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (player.lastPlayedCard != null)
                  Image.asset(
                    player.lastPlayedCard!.assetPath,
                    width: 60,
                    height: 100,
                  )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Wrap(
                    children: player.hand.map((card) {
                      if (card.isVisible) {
                        return Image.asset(card.assetPath, width: 60, height: 100);
                      } else {
                        return Image.asset(backOfCard, width: 40, height: 80);
                      }
                    }).toList(),
                  ),
                ),
                Image.asset(
                  player.ordinaryCards.first.assetPath,
                  width: 60,
                  height: 100,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
