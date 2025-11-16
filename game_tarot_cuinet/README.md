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
├── views/
│   ├── game_page.dart
│   ├── home_page.dart
│   └── player_page.dart
│
└── widgets
    ├──custom_button.dart
    └── ...
```

## Dark mode

## UI/UX

## Choix du nombre de joueurs

## Choix du pseudo

Plus de facilité a voir qui en est ou en therme de score dans la partie + annonce du vainqueur plus lisible

## Bot intéligent 
Les bots choississent leurs nombre de plis de facon intéligente en fonction de leur cartes en main. Le nombre de plis annoncé vaut le nombre de carte en main supérieur a 15.
Cela peut paraitre simple mais pourtant les bots sont (très) difficiles a battre !

## Carte de notre main trié



TODO:

faire le dernier tour avec notre carte caché mais on voit les cartes des autres 

Revue de code (guillement, code propre, code mort, getteur et setter, attribut privés...)
Commentaire et javaDoc en anglais

dark mode plus beau
Trier les mains par ordre croissant
Refaire le front-end en plus beau + ajouter un vrai plateau

changer le nombre de vie (nbre de carte au début)
bruitage
Choix de la difficulté des bots