import 'player_model.dart';
import 'card_model.dart';

class BotModel extends PlayerModel {
  BotModel({required int id, required String name, required suit, bool isDealer = false}) : super(
    id: id,
    name: name,
    suit: suit,
    isBot: true,
    isDealer: isDealer,
  );

  int computeEstimatedTricks() {
    return hand.where((card) => card.value > 15).length;
  }
}
