import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_page.dart';
import '../models/bot_model.dart';
import '../providers/game_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/selectable_option_selector.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _selectedPlayerCount = 3;
  BotDifficulty _selectedDifficulty = BotDifficulty.easy;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final provider = context.read<GameProvider>();
    if (_formKey.currentState!.validate()) {
      // Add main player
      provider.resetPlayers();
      provider.addPlayer(_nameController.text.trim(), false);

      // Add bots players
      final missing = _selectedPlayerCount - provider.players.length;
      for (var i = 1; i <= missing; i++) {
        provider.addPlayer('Bot $i', true);
      }
      _nameController.clear();

      // Start the game
      provider.startGame(context, difficulty: _selectedDifficulty);

      // Redirect to the game page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GamePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur de validation'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choix des joueurs',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSecondary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Number of players choice
              const Text(
                'Nombre de joueurs :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableOption<int>(
                    value: 3,
                    selectedValue: _selectedPlayerCount,
                    label: "3 joueurs",
                    onSelected: (value) {
                      setState(() => _selectedPlayerCount = value);
                    },
                  ),
                  const SizedBox(width: 20),
                  SelectableOption<int>(
                    value: 4,
                    selectedValue: _selectedPlayerCount,
                    label: "4 joueurs",
                    onSelected: (value) {
                      setState(() => _selectedPlayerCount = value);
                    },
                  ),
                ],
              ),

              // Main player pseudo input
              const SizedBox(height: 50),
              const Text(
                'Votre pseudo :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Entrer votre pseudo',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un pseudo';
                  }
                  if (value.length < 3 || value.length > 15) {
                    return 'Taille de pseudo incorrecte';
                  }
                  return null; // OK
                },
              ),

              // Choice of difficulty
              const SizedBox(height: 50),
              const Text(
                'Difficulté des bots :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableOption<BotDifficulty>(
                    value: BotDifficulty.easy,
                    selectedValue: _selectedDifficulty,
                    label: "Facile",
                    onSelected: (value) {
                      setState(() => _selectedDifficulty = value);
                    },
                  ),
                  const SizedBox(width: 20),
                  SelectableOption<BotDifficulty>(
                    value: BotDifficulty.hard,
                    selectedValue: _selectedDifficulty,
                    label: "Difficile",
                    onSelected: (value) {
                      setState(() => _selectedDifficulty = value);
                    },
                  ),
                ],
              ),

              // Validation button
              const SizedBox(height: 50),
              CustomButton(
                text: 'Commencer la partie !',
                onPressed: _validateForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
