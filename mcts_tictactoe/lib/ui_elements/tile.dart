import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import 'package:mcts_tictactoe/bloc/game_bloc.dart';

import 'package:mcts_tictactoe/small_classes/cords.dart';

class Tile extends StatelessWidget {
  /// A Tile acts as a base class for the squares of a board.
  ///
  /// They're implemented as elevated buttons which may hold a...
  /// String reffered to as it's [symbol]
  /// The [color] it should be
  /// It's [cords] on the board stored as i, j in a class called Cords,
  /// which gives it the ability to call out it's position when it's tapped.
  /// and a optional parameter [onPressed].
  /// By default [onPressed] will raise an event in the given context to the Bloc,
  /// alaerting the bloc of it's position. By passing in a function that
  /// does something else (or nothing) this functionality can be overwritten.
  ///
  /// Subclasses are inteneded to be different states a tile can be in,
  /// i.e. selected, unbselected, or part of a different board. However,
  /// the base class can still be used as a generic.
  static const Size _defaultTileSize = Size(100, 100);
  static const TextStyle _defaultTextStyle = TextStyle(fontSize: 65.0);

  void _defaultOnPressed(BuildContext context) {
    context.read<GameBloc>().add(HumanMoveMade(cords));
  }

  final Size? tileSize;
  final TextStyle? textStyle;

  final String symbol;
  final Color color;
  final Cords cords;
  final Function? onPressed;

  const Tile(
      {Key? key,
      required this.symbol,
      required this.color,
      required this.cords,
      this.onPressed,
      this.textStyle,
      this.tileSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: tileSize ?? _defaultTileSize,
            primary: color,
          ),
          child: Text(
            symbol,
            style: textStyle ?? _defaultTextStyle,
          ),
          onPressed: () {
            if (onPressed != null) {
              onPressed!();
            } else {
              _defaultOnPressed(context);
            }
          }),
    );
  }
}

class UnselectedTile extends Tile {
  /// A white tile with no text.

  static const String _emptySymbol = '';

  const UnselectedTile(Cords cords, {Key? key})
      : super(
            key: key, cords: cords, color: Colors.white, symbol: _emptySymbol);
}

class SelectedTile extends Tile {
  /// A tile that does nothing when pressed, and holds whichever symbol
  /// and color it's been given.

  static void _onPressed() {}
  const SelectedTile(Cords cords, Color color, String symbol, {Key? key})
      : super(
          key: key,
          cords: cords,
          symbol: symbol,
          color: color,
          onPressed: _onPressed,
        );
}

class FinishedGameTile extends Tile {
  /// A tile that defaults to grey, but can be given a color.
  /// Pressing it will reset the board.

  static const Color _defaultColor = Color(0xFF424242);

  const FinishedGameTile(Cords cords, String symbol, Color? color, {Key? key})
      : super(
            key: key,
            cords: cords,
            symbol: symbol,
            color: color ?? _defaultColor);
}
