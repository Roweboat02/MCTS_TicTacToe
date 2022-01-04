import 'package:quiver/core.dart';

class Cords {
  final int i;
  final int j;

  Cords(this.i, this.j);
  Cords.fromList(List<int> move)
      : this.i = move[0],
        this.j = move[1];

  @override
  bool operator ==(Object other) =>
      other is Cords &&
      other.runtimeType == runtimeType &&
      this.i == other.i &&
      this.j == other.j;

  @override
  int get hashCode => hash2(i.hashCode, j.hashCode);

  @override
  String toString() {
    return '($i,$j)';
  }
}
