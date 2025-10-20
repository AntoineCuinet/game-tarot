import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_page.dart';
import 'player_count_selector.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // By default
  int _selectedPlayerCount = 3;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final provider = context.read<GameProvider>();
    if (_formKey.currentState!.validate()) {
      // Add player
      provider.addPlayer(_nameController.text.trim(), false);

      // Add others player (bots)
      final missing = _selectedPlayerCount - provider.players.length;
      for (var i = 1; i <= missing; i++) {
        provider.addPlayer('Bot $i', true);
      }
      _nameController.clear();

      // Start the game
      provider.startGame(context);

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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Number of players choces
              const Text(
                'Nombre de joueurs :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayerCountSelector(
                    count: 3,
                    selectedCount: _selectedPlayerCount,
                    onSelected: (value) {
                      setState(() {
                        _selectedPlayerCount = value;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  PlayerCountSelector(
                    count: 4,
                    selectedCount: _selectedPlayerCount,
                    onSelected: (value) {
                      setState(() {
                        _selectedPlayerCount = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Pseudo
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Votre pseudo',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _validateForm,
                child: const Text('Commencer la partie !'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPlayerCountSelector(int count) {
    final bool isSelected = _selectedPlayerCount == count;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlayerCount = count;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues()
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              '$count joueurs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
