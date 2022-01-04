import 'package:flutter/material.dart';
import 'package:mcts_tictactoe/bloc/game_bloc.dart';
import 'package:mcts_tictactoe/tictactoe/cords.dart';
import '../enums/tile_states.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tile extends StatelessWidget {
  final String symbol;
  final Color color;
  final Cords cords;
  final Function? onPressed;

  static double tileSize = 100;

  const Tile({
    Key? key,
    required this.symbol,
    required this.color,
    required this.cords,
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
            style: const TextStyle(fontSize: 65.0),
          ),
          onPressed: () {
            if (onPressed == null) {
              context.read<GameBloc>().add(MoveAttempted(cords));
            } else {
              () {};
            }
          }),
    );
  }
}

class UnselectedTile extends Tile {
  static const String _emptySymbol = '';

  const UnselectedTile(Cords cords, {Key? key})
      : super(
            key: key, cords: cords, color: Colors.white, symbol: _emptySymbol);
}

class SelectedTile extends Tile {
  const SelectedTile(Cords cords, Color color, String symbol, {Key? key})
      : super(
          key: key,
          cords: cords,
          symbol: symbol,
          color: color,
        );
}

class FinishedGameTile extends Tile {
  static const Color _defaultColor = Color(0xFF424242);

  const FinishedGameTile(Cords cords, String symbol, Color? color, {Key? key})
      : super(
            key: key,
            cords: cords,
            symbol: symbol,
            color: color ?? _defaultColor);
}
