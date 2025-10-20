import 'trick_model.dart';
import 'player_model.dart';
import 'deck_model.dart';
import 'card_model.dart';

class TurnModel {
  final List<PlayerModel> players;
  final DeckModel deck;
  final int cardsPerPlayer;

  TurnModel(this.players, this.deck, this.cardsPerPlayer);

  Future<void> playTurn({
    required Future<int?> Function(PlayerModel player, int maxValue) onHumanAnnounce,
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required void Function(PlayerModel player, CardModel card) onCardPlayed,
  }) async {
    // --- Distribution ---
    for (final player in players) {
      final cards = deck.drawCards(cardsPerPlayer);
      player.receiveCards(cards);
    }

    // --- Phase d'annonces ---
    final trick = TrickModel(players);
    await trick.makeAnnouncements(
      onHumanAnnounce: onHumanAnnounce,
      onAnnounceDisplayed: onAnnounceDisplayed,
      cardsInHand: cardsPerPlayer,
    );

    // --- Phase des plis ---
    for (int trickIndex = 0; trickIndex < cardsPerPlayer; trickIndex++) {
      final trick = TrickModel(players);

      final winner = await trick.playTrick(
        onHumanPlay: onHumanPlay,
        onCardPlayed: onCardPlayed,
      );

      // Le gagnant du pli commence le prochain pli
      _rotatePlayersStartingFrom(winner);
    }

    // --- Fin de manche ---
    for (final player in players) {
      player.adjustPoints();
      player.resetTrickStats();
    }
  }

  void _rotatePlayersStartingFrom(PlayerModel winner) {
    final startIndex = players.indexOf(winner);
    final reordered = [
      ...players.sublist(startIndex),
      ...players.sublist(0, startIndex)
    ];
    players
      ..clear()
      ..addAll(reordered);
  }
}