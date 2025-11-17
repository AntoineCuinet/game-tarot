import 'package:flutter/material.dart';

import '../models/deck_model.dart';
import '../models/player_model.dart';
import '../models/trick_model.dart';
import '../viewmodels/game_view_model.dart';
import '../widgets/card_choice_input_dialog.dart';
import '../widgets/number_input_dialog.dart';


/// Provider managing the game state and interactions between the views and the GameViewModel.
/// It uses ChangeNotifier to notify listeners of state changes.
class GameProvider extends ChangeNotifier {
  final GameViewModel _viewModel = GameViewModel();

  TrickModel? _currentTrick;
  PlayerModel? _trickWinner;

  List<PlayerModel> get players => _viewModel.players;
  TrickModel? get currentTrick => _currentTrick;
  PlayerModel? get trickWinner => _trickWinner;
  DeckModel get deck => _viewModel.currentDeck;

  void addPlayer(String name, bool isBot) {
    _viewModel.addPlayer(name, isBot);
    notifyListeners();
  }

  void resetPlayers() {
    _viewModel.resetPlayers();
    notifyListeners();
  }

  void setDealer(int playerId) {
    _viewModel.setDealer(playerId);
    notifyListeners();
  }

  void showAnnouncement(PlayerModel player, int announced) {
    player.announce(announced);
    notifyListeners();
  }

  /// Starts a new game and sets up callbacks for various game events.
  Future<void> startGame(BuildContext context) async {
    await _viewModel.startNewGame(
      // Callback for human voice announcement: displays a popup and returns the integer
      onHumanAnnounce: (player, maxValue, {forbiddenValue}) async {
        return await numberInputDialog(context, maxValue, forbiddenValue: forbiddenValue);
      },

      // Callback for human card choice: displays a card choice popup
      onHumanPlay: (player, hand) async {
        return await cardChoiceInputDialog(context, hand);
      },

      // Callback called at each announcement: displays the announcement
      onAnnounceDisplayed: (player, announced) {
        player.announce(announced);
        notifyListeners();
      },

      // Callback called at each card played: displays the card played
      onCardPlayed: (player, card) {
        player.lastPlayedCard = card;
        notifyListeners();
      },

      // Callback called at the end of each turn: displays the turn winner and scores
      onTurnEnded: () {
        notifyListeners();
      },
    );
  }
}
