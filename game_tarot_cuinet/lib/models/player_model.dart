class PlayerModel {
  final String id;
  final String name;
  int score;
  bool isDealer;

  PlayerModel({required this.id, required this.name, this.score = 0, this.isDealer = false,});

  void addScore(int points) {
    score += points;
  }

  @override
  String toString() => 'Player($name, score: $score)';
}