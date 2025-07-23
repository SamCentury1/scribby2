class LevelModel {
  final int levelId;
  final String levelName;
  final int rows;
  final int columns;
  final String gameType;
  // final String objectiveType;
  final String? objectiveText;
  final List<String>? targets;
  final int? gameDuration;
  final int? timeToPlaceSeconds;
  final int difficulty;
  final List<Map<String,dynamic>> reward;

  LevelModel({
    required this.levelId,
    required this.levelName,
    required this.rows,
    required this.columns,
    required this.gameType,
    // required this.objectiveType,
    required this.objectiveText,
    required this.targets,
    required this.gameDuration,
    required this.timeToPlaceSeconds,
    required this.difficulty,
    required this.reward,
  });

  /// copy the level state
  LevelModel copy() {
    return LevelModel(
      levelId: levelId,
      levelName: levelName,
      rows: rows,
      columns: columns,
      gameType: gameType,
      // objectiveType: objectiveType,
      objectiveText: objectiveText,
      targets: targets,
      gameDuration: gameDuration,
      timeToPlaceSeconds: timeToPlaceSeconds,
      difficulty: difficulty,
      reward: reward
    );
  }

  // create a level state from JSON
  factory LevelModel.fromJson(Map<String,dynamic> json) {
    return LevelModel(
      levelId: json["levelId"] is int ? json["levelId"] : int.parse(json["levelId"]),
      levelName: json["levelName"],
      rows: json["rows"] is int ? json["rows"] : int.parse(json["rows"]),
      columns: json["columns"] is int ? json["columns"] : int.parse(json["columns"]),
      gameType: json["gameType"],
      // objectiveType: json["objectiveType"],
      objectiveText: json["objectiveText"],
      targets: List<String>.from(json["targets"]),
      gameDuration: json["gameDuration"] is int ? json["gameDuration"] : int.parse(json["gameDuration"]),
      timeToPlaceSeconds: json["timeToPlaceSeconds"] is int ? json["timeToPlaceSeconds"] : int.parse(json["timeToPlaceSeconds"]),
      difficulty: json["difficulty"] is int ? json["difficulty"] : int.parse(json["difficulty"]),  
      reward:  List<Map<String,dynamic>>.from(json["reward"]),
    );
  }

  // convert the level state to JSON
  Map<String,dynamic> toJson() {
    return {
      'levelId' : levelId,
      'levelName': levelName,
      'rows': rows,
      'columns': columns,
      'gameType': gameType,
      // 'objectiveType': objectiveType,
      'objectiveText': objectiveText,
      'targets': targets,
      'gameDuration': gameDuration,
      'timeToPlaceSeconds': timeToPlaceSeconds,
      'difficulty': difficulty,
      'reward': reward,
    };
  }
}

