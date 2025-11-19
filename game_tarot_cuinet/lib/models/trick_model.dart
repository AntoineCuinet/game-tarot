import 'bot_model.dart';
import 'card_model.dart';
import 'player_model.dart';
import '../widgets/excuse_value_input_dialog.dart';

class TrickModel {
  final List<PlayerModel> players;
  final Map<PlayerModel, CardModel> playedCards = {};

  TrickModel(this.players);

  /// Announcement phase (number of tricks and cards played)
  /// [onHumanAnnounce] → Callback for human player announcement.
  /// [onAnnounceDisplayed] → Callback for display when an announcement is made.
  /// [cardsInHand] → Number of cards in each player's hand.
  /// [startingIndex] → Index of the player who starts the announcements.
  Future<void> makeAnnouncements({
    required BotDifficulty difficulty,
    required Future<int?> Function(PlayerModel player, int maxValue, {int? forbiddenValue}) onHumanAnnounce,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required int cardsInHand,
    required int startingIndex,
  }) async {
    int totalAnnouncements = 0;

    // Ordered players starting from the specified index
    final orderedPlayers = [...players.sublist(startingIndex), ...players.sublist(0, startingIndex)];

    // Each player makes an announcement
    for (int i = 0; i < orderedPlayers.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      final player = orderedPlayers[i];
      final bool isDealer = player.isDealer;
      int announced;

      if (player.isBot && player is BotModel) { // Bots
        announced = player.computeAnnouncement(isDealer: isDealer, cardsInHand: cardsInHand, totalAnnouncements: totalAnnouncements, difficulty: difficulty);
      } else { // Humain
        final rawForbidden = isDealer ? cardsInHand - totalAnnouncements : null;
        final forbidden = (rawForbidden != null && rawForbidden >= 0) ? rawForbidden : null;
        final choice = await onHumanAnnounce(player, cardsInHand, forbiddenValue: forbidden);

        announced = choice!;
      }

      player.announce(announced);
      onAnnounceDisplayed(player, announced);
      totalAnnouncements += announced;
    }
  }

  /// Play phase (playing cards)
  /// [onHumanPlay] → Callback for human player card choice.
  /// [onCardPlayed] → Callback when a card is played.
  Future<PlayerModel> playTrick({
    required Future<CardModel?> Function(PlayerModel player, List<CardModel> hand) onHumanPlay,
    required void Function(PlayerModel player, CardModel playedCard) onCardPlayed,
  }) async {
    for (final player in players) {
      await Future.delayed(const Duration(seconds: 2));
      late CardModel playedCard;

      if (player.isBot) {
        playedCard = player.playRandomCard();
      } else {
        final chosen = await onHumanPlay(player, player.hand);
        if (chosen == null) {
          throw Exception('Le joueur humain doit choisir une carte !');
        }

        // Spacial case for Excuse card
        if (chosen.name.toLowerCase() == 'excuse') {
          final value = await excuseValueInputDialog();
          if (value != null) {
            chosen.value = value;
          }
        }

        playedCard = player.playCard(chosen);
      }

      playedCards[player] = playedCard;
      onCardPlayed(player, playedCard);
    }

    return _determineWinner();
  }

  /// Determines the winner of the trick based on the played cards.
  PlayerModel _determineWinner() {
    final entries = playedCards.entries.toList();

    entries.sort((a, b) => b.value.value.compareTo(a.value.value));
    final winner = entries.first.key;
    winner.winTrick();

    return winner;
  }
}
