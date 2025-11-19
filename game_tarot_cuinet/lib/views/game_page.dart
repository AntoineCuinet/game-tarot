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
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Game board
              Positioned(
                top: MediaQuery.of(context).size.height * 0.10,
                bottom: MediaQuery.of(context).size.height * 0.10,
                left: MediaQuery.of(context).size.width * 0.10,
                right: MediaQuery.of(context).size.width * 0.10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSecondary,
                      width: 3,
                    ),
                  ),
                ),
              ),

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
