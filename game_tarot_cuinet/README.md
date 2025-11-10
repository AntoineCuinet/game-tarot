# Mobile development project in Flutter - African tarot game

## Logique MVMM 

Séparation des rôles :

Couche	Rôle
Model	Contient les données (cartes, joueurs, état du jeu)
ViewModel	Gère la logique métier (distribuer les cartes, jouer un tour, calculer les scores)
View	Interface utilisateur (widgets, pages Flutter)
Provider	Sert d’intermédiaire entre View et ViewModel (notifie la vue quand les données changent)

```shell
lib/
│
├── main.dart
│
├── models/
│   ├── card_model.dart
│   ├── player_model.dart
│   └── ...
│
├── providers/
│   └── game_provider.dart
│
├── viewmodels/
│   └── game_view_model.dart
│
└── views/
    ├── home_page.dart
    ├── game_page.dart
    └── ...
```

## Dark mode

## UI/UX

## Choix du nombre de joueurs

## Choix du pseudo

## Bot intéligent 


rendre les bots intéligents
condition de fin
faire le dernier tour avec ntre carte caché mais on voit les cartes des autres 
v&rifier changement du dealer (doit devenir celui à sa gauche)
conditions sur le dernier qui annonce à vérifier/faire (!= somme des cartes en main)

dark mode plus beau
changer le nombre de vie (nbre de carte au début)
bruitage