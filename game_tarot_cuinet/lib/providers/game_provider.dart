import 'package:flutter/material.dart';
import '../models/trick_model.dart';
import '../models/deck_model.dart';
import '../models/player_model.dart';
import '../viewmodels/game_view_model.dart';

import '../widgets/number_input_dialog.dart';
import '../widgets/card_choice_input_dialog.dart';

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

    Future<void> startGame(BuildContext context) async {
        await _viewModel.startNewGame(
            // callback pour l'annonce humaine : affiche une popup et retourne l'entier
            onHumanAnnounce: (player, maxValue, {forbiddenValue}) async {
                return await numberInputDialog(context, maxValue, forbiddenValue: forbiddenValue);
            },

            // callback pour le choix de carte humain : affiche popup de choix de carte
            onHumanPlay: (player, hand) async {
                return await cardChoiceInputDialog(context, hand);
            },

            // callback appelé à chaque annonce (sert pour l'affichage en UI)
            onAnnounceDisplayed: (player, announced) {
                player.announce(announced); // met à jour le modèle
                notifyListeners(); // rafraîchit la vue pour montrer l'annonce
            },

            // callback appelé à chaque carte jouée
            onCardPlayed: (player, card) {
                player.lastPlayedCard = card;
                notifyListeners();
            },
            onTurnEnded: () {
                notifyListeners();
            },
        );
    }

    void showAnnouncement(PlayerModel player, int announced) {
        player.announce(announced);
        notifyListeners();
    }
}
