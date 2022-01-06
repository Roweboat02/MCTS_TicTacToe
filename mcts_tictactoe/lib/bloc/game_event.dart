part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class HumanMoveMade extends GameEvent {
  final Cords move;
  HumanMoveMade(this.move);
}

class ComputerMoveMade extends GameEvent {
  final Cords move;
  ComputerMoveMade(this.move);
}

class PlayerTypeToggled extends GameEvent {
  final TileState toggledPlayer;
  PlayerTypeToggled(this.toggledPlayer);
}
