part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class MoveAttempted extends GameEvent {
  final Cords? move;
  MoveAttempted(this.move);
}

class PlayerTypeToggled extends GameEvent {
  final TileState toggledPlayer;
  PlayerTypeToggled(this.toggledPlayer);
}
