import 'dart:math';

import 'card_model.dart';

class PlayerModel {
  final int _id;
  final String _name;
  final Suit _suit;
  bool isDealer;
  bool isBot;
  CardModel? lastPlayedCard;

  final List<CardModel> _ordinaryCards = [];
  final List<CardModel> _hand = [];

  int? announcedTricks;
  int wonTricks = 0;

  PlayerModel({required int id, required String name, required Suit suit, this.isDealer = false, this.isBot = true}):
        _id = id,
        _name = name,
        _suit = suit {_generateOrdinaryCards();}

  int get id => _id;
  String get name => _name;
  Suit get suit => _suit;
  int get pointsRemaining => _ordinaryCards.length;

  List<CardModel> get ordinaryCards => List.unmodifiable(_ordinaryCards);
  List<CardModel> get hand => List.unmodifiable(_hand);

  void announce(int tricks) => announcedTricks = tricks;
  void winTrick() => wonTricks++;

  void adjustPoints() {
    final diff = (wonTricks - announcedTricks!).abs();
    removePoints(diff);
  }

  void removePoints(int points) {
    for (int i = 0; i < points && _ordinaryCards.isNotEmpty; i++) {
      _ordinaryCards.removeLast();
    }
  }

  void receiveCards(List<CardModel> cards) {
    _hand.clear();
    _hand.addAll(cards);
  }

  CardModel playRandomCard() {
    final index = Random().nextInt(_hand.length);
    final card = _hand.removeAt(index);
    lastPlayedCard = card;
    return card;
  }

  CardModel playCard(CardModel card) {
    if (!_hand.contains(card)) throw Exception("Carte non trouvée !");
    lastPlayedCard = card;
    _hand.remove(card);
    return card;
  }

  void resetTrickStats() {
    wonTricks = 0;
    announcedTricks = null;
    lastPlayedCard = null;
  }

  void _generateOrdinaryCards() {
    const names = [
      'Roi', 'Dame', 'Cavalier', 'Valet', '10', '9', '8', '7', '6', '5', '4', '3', '2', 'As'
    ];

    final values = {
      'Roi': 14,
      'Dame': 13,
      'Cavalier': 12,
      'Valet': 11,
      for (var i = 10; i >= 2; i--) '$i': i,
      'As': 1,
    };

    for (var name in names) {
      _ordinaryCards.add(
        CardModel(
          suit: suit,
          name: name,
          value: values[name]!,
          assetPath: 'assets/CaJ-TaroTv1-${values[name]}.png', // TODO: ajouter les noms complets
        ),
      );
    }
  }
}