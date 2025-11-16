import 'package:flutter/foundation.dart';
import 'trick_model.dart';
import 'player_model.dart';
import 'deck_model.dart';
import 'card_model.dart';
import '../widgets/game_input_dialog.dart';

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
    required Future<int?> Function(PlayerModel player, int maxValue, {int? forbiddenValue}) onHumanAnnounce,
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required void Function(PlayerModel player, CardModel card) onCardPlayed,
    VoidCallback? onTurnEnded,
  }) async {
    // --- Distribution ---
    for (final player in players) {
      final cards = deck.drawCards(cardsPerPlayer);
      final bool isLastTurn = (cardsPerPlayer == 1);

      for (final card in cards) {
        if (isLastTurn) {
          card.isVisible = player.isBot; // le joueur ne voit pas sa carte
        } else {
          card.isVisible = !player.isBot; // comportement normal
        }
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

    await Future.delayed(const Duration(seconds: 2));

    // --- Phase des plis ---
    for (int trickIndex = 0; trickIndex < cardsPerPlayer; trickIndex++) {
      // Crée un ordre de jeu tournant à partir du joueur qui doit commencer
      final orderedPlayers = _getOrderedPlayers();

      final trick = TrickModel(orderedPlayers);

      final winner = await trick.playTrick(
        onHumanPlay: onHumanPlay,
        onCardPlayed: onCardPlayed,
      );

      await Future.delayed(const Duration(seconds: 2));

      for (final player in players) {
        player.clearLastPlayedCard();
      }

      await gameInputDialog(
        title: 'Fin du plis',
        message: 'Le gagnant du plis est : ${winner.name}',
        buttonText: 'Continuer',
      );

      // Le gagnant du pli commence le prochain pli
      _rotateStartingPlayer(winner);
    }

    // --- Fin de manche ---
    for (final player in players) {
      player.adjustPoints();
      player.resetTrickStats();
    }

    final scoresMessage = players
        .map((p) => '${p.name} : ${p.pointsRemaining} points restants')
        .join('\n');

    await gameInputDialog(
      title: 'Fin du tour',
      message: scoresMessage,
      buttonText: 'Continuer',
    );

    // Notifie la fin de la manche
    if (onTurnEnded != null) onTurnEnded();

    // On revient à gauche du donneur
    final dealerIndex = players.indexOf(dealer);
    _startingPlayerIndex = (dealerIndex + 1) % players.length;
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