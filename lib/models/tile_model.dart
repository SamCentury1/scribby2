class Tile {
  final int index;
  final String tileId;
  final int row;
  final int column;
  final String letter;
  final bool active;
  final bool alive;
  final int shade;
  final int angle;

  Tile({
    required this.index,
    required this.tileId,
    required this.row,
    required this.column,
    required this.letter,
    required this.active,
    required this.alive,
    required this.shade,
    required this.angle,
  });

  factory Tile.fromJson(Map<String, dynamic> json) {
    print('Parsing Tile: $json');
    return Tile(
      index: json['index'] is int ? json['index'] : int.parse(json['index']),
      tileId: json['tileId'],
      row: json['row'] is int ? json['row'] : int.parse(json['row']),
      column: json['column'] is int ? json['column'] : int.parse(json['column']),
      letter: json['letter'],
      active: json['active'] == true,
      alive: json['alive'] == true,
      shade: json['shade'] is int ? json['shade'] : int.parse(json['shade']),
      angle: json['angle'] is int ? json['angle'] : int.parse(json['angle']),
    );
  }
}