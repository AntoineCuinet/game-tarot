import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';

class GameViewModel  {
  final GameModel _game = GameModel();
  List<PlayerModel> get players => List.unmodifiable(_game.players);

  void addPlayer(String name) {
    final player = PlayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _game.addPlayer(player);
  }

  void setDealer(String playerId) => _game.setDealer(playerId);

  void startNewGame() {
    /* distribue les cartes, initialise les scores */
    print('La partie commence avec ${_game.players.length} joueurs');
  }
  void playTurn() { /* logique d’un tour */ }
}