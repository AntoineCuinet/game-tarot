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
    final deck = provider.deck;
    final cardNames = deck.getAllCardNames();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot africain'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: Colors.green[800],
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Joueur du bas (principal)
            Positioned(
              bottom: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cardNames.map((name) => Text(name)).toList(),
              ),
            ),
            Positioned(
              bottom: 20,
              child: buildPlayer(players[0]),
            ),

            // Joueur de gauche
            Positioned(
              left: 20,
              child: buildPlayer(players[1], isVertical: true),
            ),

            // Joueur du haut
            if (players.length > 3)
              Positioned(
                top: 20,
                child: buildPlayer(players[2]),
              )
            else
              Positioned(
                right: 20,
                child: buildPlayer(players[2], isVertical: true),
              ),

            // Joueur de droite
            if (players.length > 3)
              Positioned(
                right: 20,
                child: buildPlayer(players[3], isVertical: true),
              ),

            //Wrap(
            //  spacing: 4, // Espacement entre les cartes
            //  runSpacing: 4, // Espacement entre les lignes de cartes
            //  children: deck.deck.map((card) {
            //    return Image.asset(
            //      card.assetPath,
            //      width: 50, // Largeur des cartes
            //      height: 80, // Hauteur des cartes
            //    );
            //  }).toList(),
            //),
          ],
        ),
        //Image.asset('assets/CaJ-TaroTv1-1AT.png'),
      ),
    );
  }


  Widget buildPlayer(PlayerModel player, {bool isVertical = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 4),
        RotatedBox(
          quarterTurns: isVertical ? 3 : 0,
          child: Text(
            player.ordinaryCards.first.name,
            style: const TextStyle(color: Colors.white),
          )
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
