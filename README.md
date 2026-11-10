# African tarot game - Mobile development project in Flutter

## Table of Contents

- [African tarot game - Mobile development project in Flutter](#african-tarot-game---mobile-development-project-in-flutter)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Game Rules and Requirements](#game-rules-and-requirements)
  - [Application Structure](#application-structure)
    - [Model](#model)
    - [ViewModel](#viewmodel)
    - [View](#view)
    - [Provider](#provider)
  - [Project Tree](#project-tree)
  - [Player Setup](#player-setup)
    - [Number of Players](#number-of-players)
    - [Player Nickname](#player-nickname)
  - [Intelligent Bots](#intelligent-bots)
  - [Choice of Bots difficulty](#choice-of-bots-difficulty)
  - [Sorted Hand](#sorted-hand)
  - [Dark mode](#dark-mode)
  - [UI/UX Design](#uiux-design)

## Project Overview

This project is a mobile implementation of the African Tarot card game using Flutter.
It is designed with MVVM architecture, ensuring a clean separation between the data, business logic, and user interface.

The application allows human player to compete against intelligent bots in a fully interactive Tarot game, with scoring, announcements, and a visually appealing UI.

## Game Rules and Requirements

All base rules of the African Tarot game have been fully implemented.
Additionally, every requirement specified in the project instructions has been integrated, along with several extra features to improve gameplay, UI, and overall user experience.

## Application Structure

The application is structured using a true MVVM architecture, ensuring a clear separation of concerns and making the project scalable, and easy to maintain.

### Model

The Model layer contains only the data structures essential to the game logic: cards, players, scores, the deck, rounds, tricks...
They are pure Dart classes representing the current state of the game.

### ViewModel

The ViewModel contains the core business logic of the application: dealing cards, managing game phases (announcements, tricks, end of round), determining winners...

### View

The View layer represents the UI built with Flutter widgets.
The views display information exposed by the ViewModel and forward user actions back to it.
Views contain no business logic—only rendering, layout, and interactions.

### Provider

The Provider acts as a binding layer between View and ViewModel.
Whenever the ViewModel updates the state:

- The Provider notifies listeners
- The View rebuilds automatically

This keeps the UI always in sync with the game logic while maintaining a strict separation between data and visuals.

## Project Tree

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

## Player Setup

### Number of Players

Players can choose whether to play with 3 or 4 players, as requested in the project specifications.

### Player Nickname

Players can choose their nickname, making it easier to track scores and identify the winner at the end of the game (and this is cool).

## Intelligent Bots

Bots now announce the number of tricks based on the strength of their hand.
They count the number of cards higher than 15 in their hand and announce that as their expected number of tricks

This simple AI creates challenging opponents.

## Choice of Bots difficulty

The game allows you to choose at the beginning of the game whether you want to face easy or difficult bots.
The easy bots play randomly, while the difficult ones do as mentioned above.

## Sorted Hand

The hand is automatically sorted in ascending order, making it easier to see the strongest and weakest cards, and improving card selection.

## Dark mode

The application supports dark mode automatically based on the device’s theme settings.
If the device is in dark mode, the application switches to a dark theme seamlessly.

## UI/UX Design

Special attention has been given to design and usability:

- Custom buttons
- Intuitive form fields with clear labels
- Visual feedback for all actions (announcements, card play)
- ...
