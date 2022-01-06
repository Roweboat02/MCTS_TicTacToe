part of 'game_bloc.dart';

@immutable
abstract class GameState {
  final TicTacToe game;
  const GameState(this.game);

  List<List<TileState>> get board => game.board;
  Map<TileState, bool> get players => game.players;
  bool get humansTurn => game.isTurnHumans;
}

class CompMakingMove extends GameState {
  final bool visualize;
  final int count;
  const CompMakingMove(
    TicTacToe game,
    this.count,
    this.visualize,
  ) : super(game);

  bool get turn => game.turn;
}

class GameInitial extends GameState {
  const GameInitial(TicTacToe game) : super(game);
  bool get turn => game.turn;
}

class AwaitingHumanMove extends GameState {
  const AwaitingHumanMove(TicTacToe game) : super(game);
  bool get turn => game.turn;
}

class AwaitingComputerMove extends GameState {
  const AwaitingComputerMove(TicTacToe game) : super(game);
  bool get turn => game.turn;
}

class GameOver extends GameState {
  const GameOver(TicTacToe game) : super(game);
  List<Cords> get winningSquares => game.winningSquares!;
  TileState get winner => game.winner!;
}
