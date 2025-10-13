import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../viewmodels/game_view_model.dart';

class GameProvider extends ChangeNotifier {
    int _score = 0;

    int get score => _score;

    void incrementScore() {
        _score++;
        notifyListeners(); // Notifie les widgets du changement
    }

    // TODO: vrai implem
    final GameViewModel _viewModel = GameViewModel();

    void startGame() {
        _viewModel.startNewGame();
        notifyListeners();
    }
}
