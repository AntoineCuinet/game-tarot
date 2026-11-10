import 'dart:math';

import 'player_model.dart';

class BotModel extends PlayerModel {
  final Random _random = Random();

  BotModel({required super.id, required super.name, required super.suit, super.isDealer}) : super(isBot: true);

  int computeEstimatedTricks() {
    return hand.where((card) => card.value > 15).length; // Count high-value cards (> 15) as estimated tricks
  }

  int computeAnnouncement({required bool isDealer, required int cardsInHand, required int totalAnnouncements, required BotDifficulty difficulty}) {
    if (!isDealer && difficulty == BotDifficulty.easy) {
      return _random.nextInt(cardsInHand + 1);
    }

    final estimated = computeEstimatedTricks();
    final forbidden = cardsInHand - totalAnnouncements;

    // If dealer (last player to announce), avoid forbidden value
    if (isDealer && estimated == forbidden) {
      final possible = List.generate(cardsInHand + 1, (x) => x).where((x) => x != forbidden).toList();
      return possible[_random.nextInt(possible.length)];
    }

    return estimated;
  }
}

enum BotDifficulty {
  easy,
  hard
}
