class Score {
  final String userId;
  final String userName;
  final int score;
  final String triviaId;
  final String triviaName;
  final DateTime timestamp;

  Score({
    required this.userId,
    required this.userName,
    required this.score,
    required this.triviaId,
    required this.triviaName,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'score': score,
      'triviaId': triviaId,
      'triviaName': triviaName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      userId: map['userId'],
      userName: map['userName'],
      score: map['score'],
      triviaId: map['triviaId'],
      triviaName: map['triviaName'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
