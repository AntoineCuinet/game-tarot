import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/CaJ-TaroTv1-1AT.png'),
            const SizedBox(height: 24),
            Text('Score : ${gameProvider.score}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: gameProvider.incrementScore,
              child: const Text('Jouer un coup'),
            ),
          ],
        ),
      ),
    );
  }
}