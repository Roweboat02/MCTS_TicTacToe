import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcts_tictactoe/bloc/game_bloc.dart';
import 'package:mcts_tictactoe/game_state/tictactoe.dart';
import 'package:mcts_tictactoe/small_classes/cords.dart';

class ComputerPlayer extends BlocListener<GameBloc, GameState> {
  final Widget childWidget;
  final Duration stallLength;

  static bool _listenWhen(GameState previous, GameState current) {
    if (current is AwaitingComputerMove) {
      return (previous.turn != current.turn) ||
          (previous is! AwaitingComputerMove) ||
          (previous is AwaitingHumanMove && previous.turn == current.turn);
    }
    return false;
  }

  // Dart is very stupid with it's initialization order
  // Can't use member functions in initialization, but you can
  // pass member variables to static functions, allowing for currying....
  // which potentially opens up a whole can of weirdness.
  static void Function(BuildContext, GameState) _listenerMaker(
      Duration _stallLength) {
    void _listener(BuildContext context, GameState state) {
      TicTacToe _game = TicTacToe.from(state.game);
      print(_game.board);
      Future<Cords> mctsProgress = _game.makeMCTS();
      Timer(_stallLength, () {
        mctsProgress.then((Cords move) =>
            context.read<GameBloc>().add(ComputerMoveMade(move)));
      });
    }

    return _listener;
  }

  ComputerPlayer(this.childWidget, this.stallLength, {Key? key})
      : super(
            key: key,
            listenWhen: _listenWhen,
            listener: _listenerMaker(stallLength),
            child: childWidget);
}
