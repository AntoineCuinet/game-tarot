# game_tarot_cuinet

A new Flutter project.

## Logique MVMM 

Séparation des rôles :

Couche	Rôle
Model	Contient les données (cartes, joueurs, état du jeu)
ViewModel	Gère la logique métier (distribuer les cartes, jouer un tour, calculer les scores)
View	Interface utilisateur (widgets, pages Flutter)
Provider	Sert d’intermédiaire entre View et ViewModel (notifie la vue quand les données changent)

## Structure

lib/
│
├── main.dart
│
├── models/
│   ├── card_model.dart
│   ├── player_model.dart
│   └── game_model.dart
│
├── viewmodels/
│   └── game_view_model.dart
│
├── views/
│   ├── home_page.dart
│   └── game_page.dart
│
├── providers/
│   └── game_provider.dart
│
└── widgets/
    └── common_button.dart
