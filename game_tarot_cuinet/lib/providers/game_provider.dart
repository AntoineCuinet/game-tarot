import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/deck_model.dart';
import '../models/player_model.dart';
import '../viewmodels/game_view_model.dart';

class GameProvider extends ChangeNotifier {
    final GameViewModel _viewModel = GameViewModel();

    List<PlayerModel> get players => _viewModel.players;
    DeckModel get deck => _viewModel.deck;

    void addPlayer(String name) {
        _viewModel.addPlayer(name);
        notifyListeners();
    }

    void setDealer(int playerId) {
        _viewModel.setDealer(playerId);
        notifyListeners();
    }

    void startGame() {
        _viewModel.startNewGame();
        notifyListeners();
    }
}
