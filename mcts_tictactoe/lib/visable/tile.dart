import 'package:flutter/material.dart';
import 'package:mcts_tictactoe/bloc/game_bloc.dart';
import '../player_enum.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tile extends StatelessWidget {
  final String symbol;
  final Color color;
  final int i;
  final int j;
  final Function? onPressed;

  static double tileSize = 100;

  const Tile({
    Key? key,
    required this.symbol,
    required this.color,
    required this.i,
    required this.j,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(tileSize, tileSize),
            primary: color,
          ),
          child: Text(
            symbol,
          ),
          onPressed: () {
            if (onPressed == null) {
              context.read<GameBloc>().add(AttemptMove(i: i, j: j));
            } else {
              onPressed!();
            }
          }),
    );
  }
}

class UnselectedTile extends Tile {
  static const String _emptySymbol = '';

  const UnselectedTile(int i, int j, {Key? key})
      : super(key: key, i: i, j: j, color: Colors.white, symbol: _emptySymbol);
}

class SelectedTile extends Tile {

  const SelectedTile(int i, int j, Color color, String symbol, {Key? key})
      : super(
            key: key,
            i: i,
            j: j,
            symbol: symbol,
            color: color,
      );
}

class FinishedGameTile extends Tile {
  static const Color _defaultColor = Colors.grey;

  const FinishedGameTile(int i, int j, String symbol, Color? color, {Key? key})
      : super(
            key: key,
            i: i,
            j: j,
            symbol: symbol,
            color: color ?? _defaultColor);
}
