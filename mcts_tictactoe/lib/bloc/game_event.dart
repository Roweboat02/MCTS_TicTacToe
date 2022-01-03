part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class MoveAttempted extends GameEvent {
  final int? i;
  final int? j;
  MoveAttempted({this.i, this.j});
}

class PlayerTypeToggled extends GameEvent {
  final TileState toggledPlayer;
  PlayerTypeToggled(this.toggledPlayer);
}
