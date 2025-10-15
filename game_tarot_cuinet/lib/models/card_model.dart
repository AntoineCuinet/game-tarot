class CardModel {
  final int value;
  final String name;
  final Suit suit;
  final String assetPath; // path to picture

  CardModel({required this.value, required this.name, required this.suit, required this.assetPath,});
}

enum Suit {
  club,
  diamond,
  heart,
  spade,
  trump,
  excuse
}