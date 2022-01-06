import 'package:mcts_tictactoe/mcts/mcts.dart';
import '../small_classes/cords.dart';

import '../small_classes/tile_states.dart';
import '../small_classes/player_type.dart';

class TicTacToe {
  /// TicTacToe game management

  static TileState boolToBoardState(bool turn) {
    return {
      false: TileState.X,
      true: TileState.O,
    }[turn]!;
  }

  // Required params
  int boardLen;

  // Optional params
  Map<TileState, bool> players;
  List<List<TileState>>? _board;
  bool turn;

  // Internally managed params
  TileState? winner;
  List<Cords>? winningSquares;

  // Constructors
  TicTacToe(
    this.boardLen, {
    this.turn = true,
    PlayerType X = PlayerType.human,
    PlayerType O = PlayerType.human,
  }) : players = {
          TileState.X: X == PlayerType.human,
          TileState.O: O == PlayerType.human,
        };

  TicTacToe.from(TicTacToe oldGame)
      : boardLen = oldGame.boardLen,
        players = Map.from(oldGame.players),
        _board = (oldGame._board == null)
            ? null
            : oldGame._board!
                .map((List<TileState> el) =>
                    el.map((TileState e) => (e)).toList())
                .toList(),
        turn = oldGame.turn,
        winner = oldGame.winner,
        winningSquares = (oldGame.winningSquares == null)
            ? null
            : List.from(oldGame.winningSquares!);

  // Getters
  bool get isTurnHumans => players[boolToBoardState(turn)]!;
  bool get isNextTurnHumans => players[boolToBoardState(!turn)]!;
  TileState get turnsTile => boolToBoardState(turn);

  List<List<TileState>> get board => _board ??= emptyBoard;

  List<List<TileState>> get emptyBoard => List.generate(
      boardLen, (_) => List.generate(boardLen, (_) => TileState.empty));

  // Setters
  void togglePlayer(TileState toggledPlayer) {
    players[toggledPlayer] = !players[toggledPlayer]!;
  }

  void reset() {
    winner = null;
    _board = null;
    winningSquares = null;
  }

  // Move makeing
  void makeMove(Cords cord) {
    board[cord.i][cord.j] = boolToBoardState(turn);
    turn = !turn;
    _checkForWin();
    _checkForTie();
  }

  Future<Cords> makeMCTS({int simulations = 500}) async {
    Cords move = findBestMove(this, simulations);
    makeMove(move);
    return move;
  }

  void makeArbitraryMove() {
    makeMove((availableMoves()..shuffle()).first);
  }

  List<Cords> availableMoves() {
    List<Cords> moves = [];
    for (int i = 0; i < boardLen; i++) {
      for (int j = 0; j < boardLen; j++) {
        if (board[i][j] == TileState.empty) {
          moves.add(Cords(i, j));
        }
      }
    }
    return moves;
  }

  // Win checking
  void _checkForWin() {
    List<Cords> leftDiag = [];
    List<Cords> rightDiag = [];

    for (TileState player in [TileState.X, TileState.O]) {
      for (int k = 0; k < boardLen; k++) {
        // Check if tiles on diag are [player] (1 tile per iteration)
        if (board[k][k] == player) {
          rightDiag.add(Cords(k, k));
        }
        if (board[k][(boardLen - 1) - k] == player) {
          leftDiag.add(Cords(k, (boardLen - 1) - k));
        }

        // Check rows (1 row per iteration)
        if (board[k].every((element) => element == player)) {
          winner = player;
          winningSquares = List.generate(boardLen, (index) => Cords(k, index));
          break;
        }

        // Check cols (1 col per iteration)
        if (board.every((element) => element[k] == player)) {
          winner = player;
          winningSquares = List.generate(boardLen, (index) => Cords(index, k));
          break;
        }
      }
      // Check if either diag was a winning set
      if (leftDiag.length == 3) {
        winner = player;
        winningSquares = leftDiag;
        break;
      } else if (rightDiag.length == 3) {
        winner = player;
        winningSquares = rightDiag;
        break;
      }

      rightDiag.clear();
      leftDiag.clear();
    }
  }

  void _checkForTie() {
    if (winner != null) {
      return;
    }
    if (board.every((row) => row.every((val) => val != TileState.empty))) {
      winner = TileState.draw;
      winningSquares = List.generate(boardLen * boardLen,
          (index) => Cords(index ~/ boardLen, index % boardLen));
    }
  }
}
