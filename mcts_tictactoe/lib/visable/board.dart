import 'package:flutter/material.dart';
import 'package:mcts_tictactoe/tictactoe/cords.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../enums/tile_states.dart';
import 'tile.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  static const Map<TileState, String> tileSymbols = {
    TileState.X: 'X',
    TileState.O: 'O',
    TileState.empty: '',
  };

  static const Map<TileState, Color> tileColors = {
    TileState.X: Colors.red,
    TileState.O: Colors.blue,
    TileState.draw: Colors.green,
  };

  static Widget buildBoard(List<List<TileState>> board) {
    List<Widget> colChildren = [];
    for (int i = 0; i < board.length; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < board.length; j++) {
        if (board[i][j] == TileState.empty) {
          rowChildren.add(UnselectedTile(Cords(i, j)));
        } else {
          rowChildren.add(SelectedTile(Cords(i, j), tileColors[board[i][j]]!,
              tileSymbols[board[i][j]]!));
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

  static Widget buildWonBoard(List<List<TileState>> board,
      List<Cords> winningSquares, TileState winner) {
    List<Widget> colChildren = [];
    for (int i = 0; i < board.length; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < board.length; j++) {
        if (winningSquares.contains(Cords(i, j))) {
          rowChildren.add(FinishedGameTile(Cords(i, j),
              tileSymbols[board[i][j]]!, tileColors[board[i][j]]!));
        } else {
          rowChildren.add(
              FinishedGameTile(Cords(i, j), tileSymbols[board[i][j]]!, null));
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
    return BlocBuilder<GameBloc, GameState>(
        //   buildWhen: (previousState, state) {
        //   for (int i = 0; i < previousState.board.length; i++) {
        //     for (int j = 0; j < previousState.board[i].length; j++) {
        //       if (previousState.board[i][j] != state.board[i][j]) {
        //         return true;
        //       }
        //     }
        //   }
        //   return false;
        // },
        builder: (context, state) {
      if (state is! GameOver) {
        return buildBoard(state.board);
      } else {
        return buildWonBoard(state.board, state.winningSquares, state.winner);
      }
    });
  }
}
