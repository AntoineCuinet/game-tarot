import 'card_model.dart';

class DeckModel {
  final List<CardModel> _deck = [];

  DeckModel() {
    _generateTrumpsAndExcuse();
  }

  List<CardModel> get deck => List.unmodifiable(_deck);

  void shuffle() => _deck.shuffle();

  List<String> getAllCardNames() {
    return _deck.map((card) => card.name).toList();
  }

  List<CardModel> drawCards(int count) {
    final drawn = _deck.sublist(0, count); // TODO: peut être faire carte par carte
    _deck.removeRange(0, count);
    return drawn;
  }

  void _generateTrumpsAndExcuse() {
    // Trumps
    for (var i = 1; i <= 21; i++) {
      _deck.add(
        CardModel(
          suit: Suit.trump,
          name: 'Atout $i',
          value: i,
          assetPath: 'assets/CaJ-TaroTv1-${i}AT.png',
        ),
      );
    }

    // Excuse
    _deck.add(
      CardModel(
        suit: Suit.excuse,
        name: 'Excuse',
        value: 0, // Initialise to 0
        assetPath: 'assets/CaJ-TaroTv1-Exc.png',
      ),
    );
  }
}