import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'views/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projet Développement Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'Jeu du tarot africain'),
      ),
    );
  }
}
