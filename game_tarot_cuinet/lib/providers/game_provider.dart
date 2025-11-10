import 'package:flutter/material.dart';
import '../models/trick_model.dart';
import '../models/deck_model.dart';
import '../models/player_model.dart';
import '../viewmodels/game_view_model.dart';

import '../views/number_input_dialog.dart';
import '../views/card_choice_input_dialog.dart';

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
            onHumanAnnounce: (player, maxValue) async {
                return await numberInputDialog(context, maxValue);
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
            //    // pratique : garder la dernière carte jouée dans le joueur pour affichage
            //    player.lastPlayedCard = card; // assure-toi que PlayerModel possède lastPlayedCard
            //    notifyListeners();
            },
            onTurnEnded: () {
                debugPrint("Fin de manche : mise à jour des points.");
                notifyListeners();
            },
        );
    }

    void showAnnouncement(PlayerModel player, int announced) {
        player.announce(announced);
        notifyListeners();
    }
}
