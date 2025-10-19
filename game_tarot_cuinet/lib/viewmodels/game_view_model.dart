import '../models/deck_model.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../models/card_model.dart';

class GameViewModel  {
  final GameModel _game = GameModel();
  final List<Suit> _availableSuits = [
    Suit.club,
    Suit.diamond,
    Suit.heart,
    Suit.spade,
  ];
  DeckModel deck = DeckModel();
  int _playerId = 0;

  List<PlayerModel> get players => List.unmodifiable(_game.players);

  void addPlayer(String name) {
    final suit = _availableSuits[_playerId];
    final player = PlayerModel(
      id: _playerId++,
      name: name,
      suit: suit,
    );
    _game.addPlayer(player);
  }

  void setDealer(int playerId) => _game.setDealer(playerId);

  void startNewGame() {
    _game.chooseRandomDealer();
    deck.shuffle();

    // TODO: distribue les cartes de la manche
  }

  void playTurn() { /* logique d’un tour (annoncer, jouer, compter) */ }
}