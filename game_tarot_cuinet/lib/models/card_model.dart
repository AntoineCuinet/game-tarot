class CardModel {
  int value;
  final String name;
  final Suit suit;
  final String assetPath; // path to picture
  bool isVisible;

  CardModel({required this.value, required this.name, required this.suit, required this.assetPath, this.isVisible = true});
}

enum Suit {
  club,
  diamond,
  heart,
  spade,
  trump,
  excuse
}
