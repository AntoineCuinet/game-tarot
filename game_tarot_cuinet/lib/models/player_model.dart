class PlayerModel {
  final int _id;
  final String _name;
  int _score;
  bool isDealer;

  PlayerModel({required int id, required String name, int score = 0, this.isDealer = false}): _id = id, _name = name, _score = score;

  int get id => _id;
  String get name => _name;
  int get score => _score;

  void addScore(int points) {
    _score += points;
  }
}