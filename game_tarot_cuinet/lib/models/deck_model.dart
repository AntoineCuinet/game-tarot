import 'card_model.dart';

class DeckModel {
  final Map<Suit, List<CardModel>> _ordinaryCards = {
    Suit.club: [],
    Suit.diamond: [],
    Suit.heart: [],
    Suit.spade: [],
  };
  final List<CardModel> _trumps = [];

  DeckModel() {
    _generateOrdinaryCards();
    _generateTrumpsAndExcuse();
  }

  Map<Suit, List<CardModel>> get ordinaryCards => _ordinaryCards.map((k, v) => MapEntry(k, List.unmodifiable(v)));

  List<CardModel> get trumps => List.unmodifiable(_trumps);

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

    for (var suit in _ordinaryCards.keys) {
      for (var name in names) {
        _ordinaryCards[suit]!.add(
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

  void _generateTrumpsAndExcuse() {
    // Trumps
    for (var i = 1; i <= 21; i++) {
      _trumps.add(
        CardModel(
          suit: Suit.trump,
          name: 'Atout $i',
          value: i,
          assetPath: 'assets/CaJ-TaroTv1-${i}AT.png',
        ),
      );
    }

    // Excuse
    _trumps.add(
      CardModel(
        suit: Suit.excuse,
        name: 'Excuse',
        value: 0, // Initialise to 0
        assetPath: 'assets/CaJ-TaroTv1-Exc.png',
      ),
    );
  }
}