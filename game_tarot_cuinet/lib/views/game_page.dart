import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final players = provider.players;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            'Tarot africain',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(
        color: Colors.green[800],
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Joueur du bas (principal)
            Positioned(
              bottom: 50,
              child: buildPlayer(players[0]),
            ),

            // Joueur de gauche
            Positioned(
              left: 5,
              top: MediaQuery.of(context).size.height * 0.25,
              child: buildPlayer(players[1], rotationIndex: 1),
            ),

            // Joueur du haut
            if (players.length > 3)
              Positioned(
                top: 10,
                child: buildPlayer(players[2], rotationIndex: 2),
              )
            else
              Positioned(
                right: 5,
                top: MediaQuery.of(context).size.height * 0.25,
                child: buildPlayer(players[2], rotationIndex: 3),
              ),

            // Joueur de droite
            if (players.length > 3)
              Positioned(
                right: 5,
                top: MediaQuery.of(context).size.height * 0.25,
                child: buildPlayer(players[3], rotationIndex: 3),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayer(PlayerModel player, {int rotationIndex = 0}) {
    final String backOfCard = 'assets/CaJ-TaroTv1-Dos.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row (
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              player.isDealer ? Icons.star : Icons.person,
              color: player.isDealer ? Colors.amber : Colors.grey,
              size: 30,
            ),
            Text(
              player.name,
              style: TextStyle(
                fontWeight:
                player.isDealer ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              '${player.wonTricks} / ${player.announcedTricks}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ]
        ),

        RotatedBox(
          quarterTurns: rotationIndex,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (player.lastPlayedCard != null)
                    Image.asset(
                      player.lastPlayedCard!.assetPath,
                      width: 60,
                      height: 100,
                    )
                ]
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Wrap(
                      children: player.hand.map((card) {
                        if (card.isVisible)
                          return Image.asset(card.assetPath, width: 60, height: 100);
                        else
                          return Image.asset(backOfCard, width: 40, height: 80);
                      }).toList(),
                    ),
                  ),
                  Image.asset(
                    player.ordinaryCards.first.assetPath,
                    width: 60,
                    height: 100,
                  ),
                ]
              )
            ],
          ),
        )
      ]
    );
  }
}
