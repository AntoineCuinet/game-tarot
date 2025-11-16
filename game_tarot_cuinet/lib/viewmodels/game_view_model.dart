import '../main.dart';
import 'package:flutter/material.dart';

import '../models/deck_model.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import '../models/card_model.dart';
import '../models/turn_model.dart';
import '../models/bot_model.dart';
import '../widgets/game_input_dialog.dart';

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

  void addPlayer(String name, bool isBot) {
    final suit = _availableSuits[_playerId];

    final player = isBot
        ? BotModel(id: _playerId++, name: name, suit: suit)
        : PlayerModel(id: _playerId++, name: name, suit: suit, isBot: false);

    _game.addPlayer(player);
  }

  void resetPlayers() {
    _playerId = 0;
    _game.clearPlayers();
  }

  void setDealer(int playerId) => _game.setDealer(playerId);

  Future<void> startNewGame({
    required Future<int?> Function(PlayerModel player, int maxValue, {int? forbiddenValue}) onHumanAnnounce,
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required void Function(PlayerModel player, CardModel card) onCardPlayed,
    VoidCallback? onTurnEnded,
  }) async {
    PlayerModel dealer = _game.chooseRandomDealer();

    while (true) {
      // Round commence avec 5 cartes distribué par main, On recommence le tour suivant avec n-1 carte (bien réinitialiser les mains des joueurs, reprendre un deck et le remélanger)
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

        // Lorsqu'un joueur n'as plus de points -> fin, celui qui a le plus de point gagne
        if (_game.players.any((p) => p.pointsRemaining <= 0)) {
          final rankingMessage = buildFinalRanking(_game.players);

          await gameInputDialog(
            title: 'Fin de la partie',
            message: "Voici le classement final :\n\n$rankingMessage",
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

  String buildFinalRanking(List<PlayerModel> players) {
    final sorted = [...players]..sort((a, b) => b.pointsRemaining.compareTo(a.pointsRemaining));

    final buffer = StringBuffer();

    for (int i = 0; i < sorted.length; i++) {
      final p = sorted[i];
      buffer.writeln("${i + 1}. ${p.name} — ${p.pointsRemaining} points");
    }

    return buffer.toString();
  }
}