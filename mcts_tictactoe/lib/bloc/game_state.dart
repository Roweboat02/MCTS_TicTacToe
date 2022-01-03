part of 'game_bloc.dart';

@immutable
abstract class GameState {
  final TicTacToe game;
  const GameState(this.game);

  List<List<TileState>> get board => game.board;
  Map<TileState, bool> get players => game.players;
}

class GameInitial extends GameState {
  const GameInitial(TicTacToe game) : super(game);
  bool get turn => game.turn;
}

class GameInProgress extends GameState {
  const GameInProgress(TicTacToe game) : super(game);
  bool get turn => game.turn;
}

class GameOver extends GameState {
  const GameOver(TicTacToe game) : super(game);
  List<List<int>> get winningSquares => game.winningSquares!;
  TileState get winner => game.winner!;
}
