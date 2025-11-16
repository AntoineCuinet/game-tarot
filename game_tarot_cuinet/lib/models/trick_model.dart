import 'dart:math';
import '../widgets/excuse_value_input_dialog.dart';
import 'player_model.dart';
import 'card_model.dart';
import 'bot_model.dart';

class TrickModel {
  final List<PlayerModel> players;
  final Map<PlayerModel, CardModel> playedCards = {};
  final Random _random = Random();

  TrickModel(this.players);

  // Annonces
  Future<void> makeAnnouncements({
    required Future<int?> Function(PlayerModel player, int maxValue, {int? forbiddenValue}) onHumanAnnounce,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required int cardsInHand,
    required int startingIndex,
  }) async {
    int totalAnnouncements = 0;

    // Création de l'ordre de passage
    final orderedPlayers = [
      ...players.sublist(startingIndex),
      ...players.sublist(0, startingIndex)
    ];

    for (int i = 0; i < orderedPlayers.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      final player = orderedPlayers[i];
      final bool isDealer = player.isDealer;
      int announced;

      // Bots
      if (player.isBot && player is BotModel) {
        final estimated = player.computeEstimatedTricks();

        if (isDealer) {
          final forbidden = cardsInHand - totalAnnouncements;

          if (estimated == forbidden) {
            final possible = List.generate(cardsInHand + 1, (x) => x)
                .where((x) => x != forbidden)
                .toList();
            announced = possible[_random.nextInt(possible.length)];
          } else {
            announced = estimated;
          }
        } else {
          announced = estimated;
        }

      // Humain
      } else {
        // Valeur interdite car somme == nbre de carte en main
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

  //JEU DES CARTES
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

        // Cas spécial: Excuse
        if (chosen.name.toLowerCase() == 'excuse') {
          final value = await excuseValueInputDialog();
          if (value != null) {
            chosen.value = value; // met à jour la valeur de la carte Excuse
          }
        }

        playedCard = player.playCard(chosen);
      }

      playedCards[player] = playedCard;
      onCardPlayed(player, playedCard);
    }

    return _determineWinner();
  }

  PlayerModel _determineWinner() {
    final entries = playedCards.entries.toList();

    entries.sort((a, b) => b.value.value.compareTo(a.value.value));
    final winner = entries.first.key;
    winner.winTrick();

    return winner;
  }
}