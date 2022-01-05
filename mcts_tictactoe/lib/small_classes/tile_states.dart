enum TileState {
  /// [TileState] is a bad name for this enum.
  /// These four states are needed in many places, *often* all 4,
  /// but other times in various combinations.
  /// Instead of making 4! enums, there's just [TileState]
  X,
  O,
  empty,
  draw,
}
