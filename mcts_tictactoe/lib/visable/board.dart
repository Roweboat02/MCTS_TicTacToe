import 'package:flutter/material.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../player_enum.dart';
import 'tile.dart';

class Board extends StatelessWidget {
  final int boardLen;
  const Board(this.boardLen, {Key? key}) : super(key: key);

  static const Map<PlayerType, String> tileSymbols = {
    PlayerType.X: 'X',
    PlayerType.O: 'X',
  };

  static const Map<PlayerType, Color> tileColors = {
    PlayerType.X: Colors.red,
    PlayerType.O: Colors.blue,
    PlayerType.draw: Colors.green,
  };

  static Widget buildBoard(List<List<int>> board) {
    List<Widget> colChildren = [];
    for (int i = 0; i < board.length; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < board.length; j++) {
        if (board[i][j] == PlayerType.empty.index) {
          rowChildren.add(UnselectedTile(i, j));
        } else {
          rowChildren.add(SelectedTile(
              i, j, tileColors[board[i][j]]!, tileSymbols[board[i][j]]!));
        }
      }
      colChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colChildren,
    );
  }

  static Widget buildWonBoard(List<List<int>> board,
      List<List<int>> winningSquares, PlayerType winner) {
    List<Widget> colChildren = [];
    for (int i = 0; i < board.length; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < board.length; j++) {
        if (winningSquares.contains([i, j])) {
          rowChildren.add(FinishedGameTile(
              i, j, tileSymbols[board[i][j]]!, tileColors[board[i][j]]!));
        } else {
          rowChildren
              .add(FinishedGameTile(i, j, tileSymbols[board[i][j]]!, null));
        }
      }
      colChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(buildWhen: (previousState, state) {
      return previousState.runtimeType != state.runtimeType;
    }, builder: (context, state) {
      if (state is! GameOver) {
        return buildBoard(state.board);
      } else {
        return buildWonBoard(state.board, state.winningSquares, state.winner);
      }
    });
  }
}
