class Stats {
  int gamePlayed;
  int gameWon;
  int winPercentage;
  int currentStreak;
  int maxStreak;

  Stats({
    required this.gamePlayed,
    required this.gameWon,
    required this.winPercentage,
    required this.currentStreak,
    required this.maxStreak,
  });

  factory Stats.zero() => Stats(
        gamePlayed: 0,
        gameWon: 0,
        winPercentage: 0,
        currentStreak: 0,
        maxStreak: 0,
      );

  factory Stats.fromList(List<String> stats) => Stats(
        gamePlayed: int.parse(stats[0]),
        gameWon: int.parse(stats[1]),
        winPercentage: int.parse(stats[2]),
        currentStreak: int.parse(stats[3]),
        maxStreak: int.parse(stats[4]),
      );

  List<String> toList() => <String>[
        gamePlayed.toString(),
        gameWon.toString(),
        winPercentage.toString(),
        currentStreak.toString(),
        maxStreak.toString(),
      ];
}
