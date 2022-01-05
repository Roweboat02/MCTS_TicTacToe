import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';

import 'package:mcts_tictactoe/small_classes/cords.dart';
import '../small_classes/tile_states.dart';
import 'tile.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  static _rowConstructor(List<Tile> children) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: children);

  static _colConstructor(List<Row> children) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: children);

  static String _symbolFromTileState(TileState player) {
    return {
      TileState.X: 'X',
      TileState.O: 'O',
      TileState.empty: '',
    }[player]!;
  }

  static Color _colorFromTileState(TileState player) {
    return {
      TileState.X: Colors.red,
      TileState.O: Colors.blue,
      TileState.draw: Colors.green,
    }[player]!;
  }

  static Widget _buildBoard(List<List<TileState>> board) {
    List<Row> colChildren = [];

    for (int i = 0; i < board.length; i++) {
      List<Tile> rowChildren = [];

      for (int j = 0; j < board.length; j++) {
        late Tile tile;
        if (board[i][j] == TileState.empty) {
          tile = UnselectedTile(Cords(i, j));
        } else {
          tile = SelectedTile(Cords(i, j), _colorFromTileState(board[i][j]),
              _symbolFromTileState(board[i][j]));
        }
        rowChildren.add(tile);
      }
      colChildren.add(_rowConstructor(rowChildren));
    }
    return _colConstructor(colChildren);
  }

  static Widget _buildWonBoard(
      List<List<TileState>> board, List<Cords> winningSquares) {
    List<Row> colChildren = [];

    for (int i = 0; i < board.length; i++) {
      List<Tile> rowChildren = [];

      for (int j = 0; j < board.length; j++) {
        rowChildren.add(FinishedGameTile(
          Cords(i, j),
          _symbolFromTileState(board[i][j]),
          winningSquares.contains(Cords(i, j))
              ? _colorFromTileState(board[i][j])
              : null,
        ));
      }

      colChildren.add(_rowConstructor(rowChildren));
    }
    return _colConstructor(colChildren);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      if (state is GameInitial || state is GameInProgress) {
        return _buildBoard(state.board);
      } else if (state is GameOver) {
        return _buildWonBoard(state.board, state.winningSquares);
      } else {
        //Left in case of need of alternate state handling.
        return _buildBoard(state.board);
      }
    });
  }
}
