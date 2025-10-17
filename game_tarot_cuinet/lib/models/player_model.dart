class PlayerModel {
  final int _id;
  final String _name;
  int _pointsRemaining = 14; // Begining point (with 14 cards)
  bool isDealer;

  PlayerModel({required int id, required String name, this.isDealer = false}): _id = id, _name = name;

  int get id => _id;
  String get name => _name;
  int get pointsRemaining => _pointsRemaining;

  void removePoints(int points) {
    _pointsRemaining = (_pointsRemaining - points).clamp(0, 14);
  }
}