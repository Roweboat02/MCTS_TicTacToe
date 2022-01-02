part of 'game_bloc.dart';

@immutable
abstract class GameState {
  final List<List<int>> board;
  const GameState(this.board);

}

class GameInitial extends GameState {
  final bool initialTurn;
  final bool isEmpty;
  const GameInitial(List<List<int>> board, this.initialTurn, this.isEmpty):super(board);
}

class GameInProgress extends GameState {
  final currentTurn;
  const GameInProgress(List<List<int>> board, this.currentTurn):super(board);
}

class GameOver extends GameState {
  final PlayerType winner;
  final List<List<int>> winningSquares;
  const GameOver(List<List<int>> board, this.winner, this.winningSquares):super(board);
}

