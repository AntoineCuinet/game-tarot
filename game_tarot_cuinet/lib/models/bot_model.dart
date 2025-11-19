import 'player_model.dart';

class BotModel extends PlayerModel {
  BotModel({required super.id, required super.name, required suit, super.isDealer}) : super(
    suit: suit,
    isBot: true,
  );

  int computeEstimatedTricks() {
    return hand.where((card) => card.value > 15).length;
  }
}
