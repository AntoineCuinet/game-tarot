import 'dart:math';

import 'player_model.dart';
import 'card_model.dart';

class TrickModel {
  final List<PlayerModel> players;
  final Map<PlayerModel, CardModel> playedCards = {};
  final Random _random = Random();

  TrickModel(this.players);

  // Annonces
  Future<void> makeAnnouncements({
    required Future<int?> Function(PlayerModel player, int maxValue) onHumanAnnounce,
    required void Function(PlayerModel player, int announced) onAnnounceDisplayed,
    required int cardsInHand,
  }) async {
    int totalAnnouncements = 0;

    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      final bool isDealer = player.isDealer;

      int announced;

      if (player.isBot) {
        // Les bots choisissent aléatoirement, sauf le dealer à la fin
        if (isDealer) {
          final max = cardsInHand;
          final forbidden = cardsInHand - totalAnnouncements;
          final possible = List.generate(max + 1, (i) => i)
              .where((x) => x != forbidden)
              .toList();
          announced = possible[_random.nextInt(possible.length)];
        } else {
          announced = _random.nextInt(cardsInHand + 1);
        }
      } else {
        // Demande à l'utilisateur (pop-up)
        final choice = await onHumanAnnounce(player, cardsInHand);
        if (choice == null) {
          throw Exception("Le joueur humain doit annoncer un nombre !");
        }
        announced = choice;
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
      late CardModel playedCard;

      if (player.isBot) {
        playedCard = player.playRandomCard();
      } else {
        final chosen = await onHumanPlay(player, player.hand);
        if (chosen == null) {
          throw Exception("Le joueur humain doit choisir une carte !");
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