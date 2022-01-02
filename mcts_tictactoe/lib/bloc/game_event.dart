part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class AttemptMove extends GameEvent{
  final int j;
  final int i;
  AttemptMove({required this.i, required this.j});
}

class PlayerTypeToggled extends GameEvent{


}


