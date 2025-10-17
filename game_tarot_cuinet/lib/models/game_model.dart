import 'dart:math';
import 'player_model.dart';
import 'deck_model.dart';

class GameModel {
  final List<PlayerModel> _players;

  GameModel({List<PlayerModel>? players}) : _players = players ?? [];

  List<PlayerModel> get players => List.unmodifiable(_players);

  int get playerCount => _players.length;

  PlayerModel get dealer => _players.firstWhere((p) => p.isDealer, orElse: () => throw Exception('Aucun dealer défini'));

  void addPlayer(PlayerModel player) {
    _players.add(player);
  }

  void setDealer(int playerId) {
    for (var p in _players) {
      p.isDealer = (p.id == playerId);
    }
  }

  void chooseRandomDealer() {
    if (_players.isEmpty) return;

    // Random whith 0 and players.length - 1
    final randomIndex = Random().nextInt(_players.length);
    final selectedPlayer = _players[randomIndex];

    setDealer(selectedPlayer.id);
  }

  void nextDealer() {
    if (_players.isEmpty) return;

    final currentIndex = _players.indexWhere((p) => p.isDealer);
    if (currentIndex != -1) {
      _players[currentIndex].isDealer = false;
    }

    final nextIndex = (currentIndex + 1) % _players.length;
    _players[nextIndex].isDealer = true;
  }
}