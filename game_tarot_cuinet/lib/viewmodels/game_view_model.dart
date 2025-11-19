import '../main.dart';
import 'package:flutter/material.dart';

import '../models/bot_model.dart';
import '../models/card_model.dart';
import '../models/deck_model.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../models/turn_model.dart';
import '../widgets/game_input_dialog.dart';

/// ViewModel managing the game logic and state.
/// It interacts with the GameModel and provides methods to manipulate the game state.
class GameViewModel {
  final GameModel _game = GameModel();
  final List<Suit> _availableSuits = [
    Suit.club,
    Suit.diamond,
    Suit.heart,
    Suit.spade,
  ];
  DeckModel deck = DeckModel();
  int _playerId = 0;
  int _idRound = 1;

  List<PlayerModel> get players => List.unmodifiable(_game.players);
  DeckModel get currentDeck => deck;

  void setDealer(int playerId) => _game.setDealer(playerId);

  void addPlayer(String name, bool isBot) {
    final suit = _availableSuits[_playerId];

    final player = isBot ? BotModel(id: _playerId++, name: name, suit: suit) : PlayerModel(id: _playerId++, name: name, suit: suit, isBot: false);

    _game.addPlayer(player);
  }

  void resetPlayers() {
    _playerId = 0;
    _game.clearPlayers();
  }

  /// Starts a new game and manages the game flow with provided callbacks for user interactions.
  Future<void> startNewGame({
    required Future<int?> Function(PlayerModel player, int maxValue, {int? forbiddenValue}) onHumanAnnounce,
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required void Function(PlayerModel player, CardModel card) onCardPlayed,
    VoidCallback? onTurnEnded,
  }) async {
    PlayerModel dealer = _game.chooseRandomDealer();

    // Main game loop
    while (true) {
      // Rounds begin with 5 cards dealt per hand, then the next round starts with n-1 cards
      for (int cards = 5; cards > 0; cards--) {
        deck = DeckModel();
        deck.shuffle();

        final turn = TurnModel(players, deck, cards, dealer);

        await turn.playTurn(
          onHumanAnnounce: onHumanAnnounce,
          onHumanPlay: onHumanPlay,
          onAnnounceDisplayed: onAnnounceDisplayed,
          onCardPlayed: onCardPlayed,
          onTurnEnded: onTurnEnded,
        );

        // Check for end of game
        if (_game.players.any((p) => p.pointsRemaining <= 0)) {
          final rankingMessage = buildFinalRanking(_game.players);

          await gameInputDialog(
            title: 'Fin de la partie',
            message: 'Voici le classement final :\n\n$rankingMessage',
            buttonText: 'Retour à l\'accueil',
            onConfirm: () {
              final context = navigatorKey.currentContext;
              if (context != null) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          );

          return;
        }
      }

      dealer = _game.nextDealer();
      await gameInputDialog(
        title: 'Fin de la manche $_idRound',
        message: 'La manche est terminée.\nLe nouveau donneur est : ${dealer.name}',
        buttonText: 'Continuer',
      );
      _idRound ++;
    }
  }

  /// Builds a string representing the final ranking of players based on their remaining points.
  String buildFinalRanking(List<PlayerModel> players) {
    final sorted = [...players]..sort((a, b) => b.pointsRemaining.compareTo(a.pointsRemaining));
    final buffer = StringBuffer();

    for (int i = 0; i < sorted.length; i++) {
      final p = sorted[i];
      buffer.writeln('${i + 1}. ${p.name} — ${p.pointsRemaining} points');
    }

    return buffer.toString();
  }
}
