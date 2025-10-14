import 'dart:math';
import 'player_model.dart';

class GameModel {
  final List<PlayerModel> players;

  GameModel({List<PlayerModel>? players}) : players = players ?? [];

  void addPlayer(PlayerModel player) {
    players.add(player);
  }

  void setDealer(int playerId) {
    for (var p in players) {
      p.isDealer = (p.id == playerId);
    }
  }

  void chooseRandomDealer() {
    if (players.isEmpty) return;

    // Random whith 0 and players.length - 1
    final randomIndex = Random().nextInt(players.length);
    final selectedPlayer = players[randomIndex];

    setDealer(selectedPlayer.id);
  }

  void nextDealer() {
    if (players.isEmpty) return;

    int currentIndex = players.indexWhere((p) => p.isDealer);
    if (currentIndex != -1) {
      players[currentIndex].isDealer = false;
    }

    int nextIndex;
    if (currentIndex == -1 || currentIndex == players.length - 1) {
      nextIndex = 0;
    } else {
      nextIndex = currentIndex + 1;
    }

    players[nextIndex].isDealer = true;
  }
}