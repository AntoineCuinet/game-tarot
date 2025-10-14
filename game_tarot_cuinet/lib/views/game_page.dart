import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

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
        title: const Text('Tarot africain'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/CaJ-TaroTv1-1AT.png'),
            const SizedBox(height: 20),
            Text(
              'Nombre de joueurs : ${players.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final isDealer = player.isDealer;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(
                        isDealer ? Icons.star : Icons.person,
                        color: isDealer ? Colors.amber : Colors.grey,
                      ),
                      title: Text(
                        player.name,
                        style: TextStyle(
                          fontWeight: isDealer ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: isDealer ? const Text('Donneur') : const Text('Receveur'),
                    ),
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}
