import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';

class GameViewModel  {
  final GameModel _game = GameModel();
  List<PlayerModel> get players => List.unmodifiable(_game.players);
  int _id = 0;

  void addPlayer(String name) {
    final player = PlayerModel(
      id: _id++,
      name: name,
    );
    _game.addPlayer(player);
  }

  void setDealer(int playerId) => _game.setDealer(playerId);

  void startNewGame() {
    _game.chooseRandomDealer();

    // TODO: distribue les cartes, initialise les scores
  }

  void playTurn() { /* logique d’un tour */ }
}