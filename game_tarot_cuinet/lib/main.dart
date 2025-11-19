/*              Mobile development             */
/*              Project in Flutter             */
/*                CUINET ANTOINE               */
/*               M1 Informatique               */
/*                UMLP - UFR ST                */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'views/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  final ColorScheme lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF523B31),
    onPrimary: Colors.white,
    secondary: Color(0xFF0F8D2D),
    onSecondary: Colors.white,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  final ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF523B31),
    onPrimary: Colors.white,
    secondary: Color(0xFF0F502D),
    onSecondary: Colors.white,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Color(0xFF262626),
    onSurface: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projet De Développement Mobile',
        theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
        darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: const HomePage(title: 'Jeu du tarot africain'),
      ),
    );
  }
}
