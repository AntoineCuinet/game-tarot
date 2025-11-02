import 'package:flutter/foundation.dart'; //TODO: En cours
import 'trick_model.dart';
import 'player_model.dart';
import 'deck_model.dart';
import 'card_model.dart';

class TurnModel {
  final List<PlayerModel> players;
  final DeckModel deck;
  final int cardsPerPlayer;
  final PlayerModel dealer;
  int _startingPlayerIndex = 0;

  TurnModel(this.players, this.deck, this.cardsPerPlayer, this.dealer) {
    final dealerIndex = players.indexOf(dealer);
    _startingPlayerIndex = (dealerIndex + 1) % players.length;
  }

  Future<void> playTurn({
    required Future<int?> Function(PlayerModel player, int maxValue) onHumanAnnounce,
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required void Function(PlayerModel player, CardModel card) onCardPlayed,
    VoidCallback? onTurnEnded, //TODO: En cours
  }) async {
    // --- Distribution ---
    for (final player in players) {
      final cards = deck.drawCards(cardsPerPlayer);
      for (final card in cards) {
        card.isVisible = !player.isBot; // Cache les cartes des autres joueurs
      }
      player.receiveCards(cards);
    }

    // --- Phase d'annonces ---
    final trick = TrickModel(players);
    await trick.makeAnnouncements(
      onHumanAnnounce: onHumanAnnounce,
      onAnnounceDisplayed: onAnnounceDisplayed,
      cardsInHand: cardsPerPlayer,
      startingIndex: _startingPlayerIndex,
    );

    // --- Phase des plis ---
    for (int trickIndex = 0; trickIndex < cardsPerPlayer; trickIndex++) {
      // Crée un ordre de jeu tournant à partir du joueur qui doit commencer
      final orderedPlayers = _getOrderedPlayers();

      final trick = TrickModel(orderedPlayers);

      final winner = await trick.playTrick(
        onHumanPlay: onHumanPlay,
        onCardPlayed: onCardPlayed,
      );

      // Le gagnant du pli commence le prochain pli
      _rotateStartingPlayer(winner);
    }

    // --- Fin de manche ---
    for (final player in players) {
      player.adjustPoints();
      player.resetTrickStats();
    }

    // On revient à gauche du donneur
    final dealerIndex = players.indexOf(dealer);
    _startingPlayerIndex = (dealerIndex + 1) % players.length;

    // Notifie la fin de la manche
    if (onTurnEnded != null) onTurnEnded(); //TODO: En cours
  }

  /// Retourne la liste des joueurs dans l'ordre de jeu actuel
  List<PlayerModel> _getOrderedPlayers() {
    return [
      ...players.sublist(_startingPlayerIndex),
      ...players.sublist(0, _startingPlayerIndex)
    ];
  }

  /// Met à jour l'index du joueur qui commencera le prochain pli
  void _rotateStartingPlayer(PlayerModel winner) {
    final winnerIndex = players.indexOf(winner);
    if (winnerIndex != -1) {
      _startingPlayerIndex = winnerIndex;
    }
  }
}