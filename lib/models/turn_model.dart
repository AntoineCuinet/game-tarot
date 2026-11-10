import 'package:flutter/foundation.dart';

import 'bot_model.dart';
import 'card_model.dart';
import 'deck_model.dart';
import 'player_model.dart';
import 'trick_model.dart';
import '../widgets/game_input_dialog.dart';

class TurnModel {
  final List<PlayerModel> players;
  final DeckModel deck;
  final int cardsPerPlayer;
  final PlayerModel dealer;
  final BotDifficulty difficulty;
  int _startingPlayerIndex = 0;

  TurnModel(this.players, this.deck, this.cardsPerPlayer, this.dealer, this.difficulty) {
    final dealerIndex = players.indexOf(dealer);
    _startingPlayerIndex = (dealerIndex + 1) % players.length;
  }

  /// Execute a full turn (distribution, announcements, tricks, scoring)
  /// [onHumanAnnounce] → Callback for human player announcement.
  /// [onHumanPlay] → Callback for human player card choice.
  /// [onAnnounceDisplayed] → Callback for display when an announcement is made.
  /// [onCardPlayed] → Callback when a card is played.
  /// [onTurnEnded] → Optional callback when the turn ends.
  Future<void> playTurn({
    required Future<int?> Function(PlayerModel player, int maxValue, {int? forbiddenValue}) onHumanAnnounce,
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required void Function(PlayerModel player, CardModel card) onCardPlayed,
    VoidCallback? onTurnEnded,
  }) async {
    // Distribution of cards
    for (final player in players) {
      final cards = deck.drawCards(cardsPerPlayer);
      final bool isLastTurn = (cardsPerPlayer == 1);

      for (final card in cards) {
        if (isLastTurn) {
          card.isVisible = player.isBot; // The players can see their card
        } else {
          card.isVisible = !player.isBot; // Normal behavior, the players see their own cards
        }
      }
      player.receiveCards(cards);
      player.sortHand();
    }

    // Announcement phase
    final trick = TrickModel(players);
    await trick.makeAnnouncements(
      difficulty: difficulty,
      onHumanAnnounce: onHumanAnnounce,
      onAnnounceDisplayed: onAnnounceDisplayed,
      cardsInHand: cardsPerPlayer,
      startingIndex: _startingPlayerIndex,
    );

    await Future.delayed(const Duration(seconds: 2));

    // Trick playing phase
    for (int trickIndex = 0; trickIndex < cardsPerPlayer; trickIndex++) {
      // Create a rotating play order starting from the player who should start
      final orderedPlayers = _getOrderedPlayers();

      final trick = TrickModel(orderedPlayers);
      final winner = await trick.playTrick(onHumanPlay: onHumanPlay, onCardPlayed: onCardPlayed);

      await Future.delayed(const Duration(seconds: 2));

      for (final player in players) {
        player.clearLastPlayedCard();
      }

      await gameInputDialog(
        title: 'Fin du plis',
        message: 'Le gagnant du plis est : ${winner.name}',
        buttonText: 'Continuer',
      );

      // The winner of the trick starts the next one
      _rotateStartingPlayer(winner);
    }

    // End of turn
    for (final player in players) {
      player.adjustPoints();
      player.resetTrickStats();
    }

    final scoresMessage = players.map((p) => '${p.name} : ${p.pointsRemaining} points restants').join('\n');

    await gameInputDialog(
      title: 'Fin du tour',
      message: scoresMessage,
      buttonText: 'Continuer',
    );

    // Callback when the turn ends
    if (onTurnEnded != null) onTurnEnded();

    // Return to the left of the dealer
    final dealerIndex = players.indexOf(dealer);
    _startingPlayerIndex = (dealerIndex + 1) % players.length;
  }

  /// Returns the list of players in the current play order
  List<PlayerModel> _getOrderedPlayers() {
    return [
      ...players.sublist(_startingPlayerIndex),
      ...players.sublist(0, _startingPlayerIndex)
    ];
  }

  /// Updates the index of the player who will start the next trick
  void _rotateStartingPlayer(PlayerModel winner) {
    final winnerIndex = players.indexOf(winner);
    if (winnerIndex != -1) {
      _startingPlayerIndex = winnerIndex;
    }
  }
}
