part of 'game_bloc.dart';

@immutable
abstract class GameState {
  final List<List<int>> board;
  final Map<PlayerType, bool> humanPlayers;
  const GameState(this.board, this.humanPlayers);

}

class GameInitial extends GameState {
  final bool initialTurn;
  final bool isEmpty;
  const GameInitial(List<List<int>> board, Map<PlayerType, bool> humanPlayers, this.initialTurn, this.isEmpty):super(board, humanPlayers);
}

class GameInProgress extends GameState {
  final bool currentTurn;
  const GameInProgress(List<List<int>> board, Map<PlayerType, bool> humanPlayers, this.currentTurn):super(board, humanPlayers);
}

class GameOver extends GameState {
  final PlayerType winner;
  final List<List<int>> winningSquares;
  const GameOver(List<List<int>> board, Map<PlayerType, bool> humanPlayers, this.winner, this.winningSquares):super(board, humanPlayers);
}

