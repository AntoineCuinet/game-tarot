import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../widgets/build_player.dart';

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
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: Container(
          color: Colors.green[800],
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bottom player (main)
              Positioned(
                bottom: 5,
                child: buildPlayer(players[0]),
              ),

              // Left player
              Positioned(
                left: 5,
                top: MediaQuery.of(context).size.height * 0.25,
                child: buildPlayer(players[1], rotationIndex: 1),
              ),

              // Top player or third player
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

              // Right player
              if (players.length > 3)
                Positioned(
                  right: 5,
                  top: MediaQuery.of(context).size.height * 0.25,
                  child: buildPlayer(players[3], rotationIndex: 3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
