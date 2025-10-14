import 'player_model.dart';

class GameModel {
  final List<PlayerModel> players;

  GameModel({List<PlayerModel>? players}) : players = players ?? [];

  void addPlayer(PlayerModel player) {
    players.add(player);
  }

  void setDealer(String playerId) {
    for (var p in players) {
      p.isDealer = (p.id == playerId);
    }
  }
}