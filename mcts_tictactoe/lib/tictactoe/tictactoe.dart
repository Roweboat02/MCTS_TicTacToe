import 'package:mcts_tictactoe/tictactoe/mcts.dart';
import 'package:mcts_tictactoe/visable/board.dart';

import '../enums/board_states.dart';
import '../enums/player_type.dart';

class TicTacToe {
  //Required to be inputed
  int boardLen;

  Map<TileState, bool> players;
  List<List<TileState>>? _board;

  static Map<bool, TileState> boolToBoardState = {
    false: TileState.X,
    true: TileState.O,
  };

  bool turn;
  TileState? winner;

  List<List<int>>? winningSquares;

  bool get humansTurn => players[boolToBoardState[turn]]!;
  TileState get turnsTile => boolToBoardState[turn]!;

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
      : this.boardLen = oldGame.boardLen,
        this.players = oldGame.players,
        this._board = oldGame._board,
        this.turn = oldGame.turn,
        this.winner = oldGame.winner,
        this.winningSquares = oldGame.winningSquares;

  List<List<TileState>> get board => _board ??= emptyBoard;

  List<List<TileState>> get emptyBoard => List.generate(
      boardLen, (_) => List.generate(boardLen, (_) => TileState.empty));

  void makeMove(int i, int j) {
    //POTENTIAL ERROR WITH PASS-BY-REF
    board[i][j] = boolToBoardState[turn]!;
    turn = !turn;
    _checkForWin();
    _checkForTie();
  }

  void makeMCTS() {
    List<int> move = findBestMove(this, 500);
    makeMove(move[0], move[1]);
  }

  void makeArbitraryMove() {
    List<int> move = availableMoves().first;
    makeMove(move[0], move[1]);
  }

  void togglePlayer(TileState toggledPlayer) {
    players[toggledPlayer] = !players[toggledPlayer]!;
  }

  void _checkForWin() {
    late List<List<int>> leftDiag;
    late List<List<int>> rightDiag;

    for (TileState player in [TileState.X, TileState.O]) {
      rightDiag = leftDiag = [];

      for (int k = 0; k < boardLen; k++) {
        if (board[k][k] == player) {
          rightDiag.add([k, k]);
        }
        if (board[k][(boardLen - 1) - k] == player) {
          leftDiag.add([k, (boardLen - 1) - k]);
        } // check if tiles on diag are turn

        if (board[k].every((element) => element == player)) {
          winner = player;
          winningSquares = List.generate(boardLen, (index) => [k, index]);
          break;
        } // check each row
        if (board.every((element) => element[k] == player)) {
          winner = player;
          winningSquares = List.generate(boardLen, (index) => [index, k]);
          break;
        } // check each col
        if (leftDiag.length == 3) {
          winner = player;
          winningSquares = leftDiag;
          break;
        } else if (rightDiag.length == 3) {
          winner = player;
          winningSquares = rightDiag;
          break;
        }
      }
    }
  }

  void _checkForTie() {
    if (board
        .every((values) => values.every((value) => value != TileState.empty))) {
      winner = TileState.draw;
      winningSquares = List.generate(boardLen * boardLen,
          (index) => [index ~/ boardLen, index % boardLen]);
    }
  }

  List<List<int>> availableMoves() {
    List<List<int>> moves = [];
    for (int i = 0; i < boardLen; i++) {
      for (int j = 0; j < boardLen; j++) {
        if (board[i][j] == TileState.empty) {
          moves.add([i, j]..length = 2);
        }
      }
    }
    return moves;
  }
}
