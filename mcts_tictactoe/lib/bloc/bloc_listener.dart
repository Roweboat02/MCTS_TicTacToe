import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcts_tictactoe/bloc/game_bloc.dart';
import 'package:mcts_tictactoe/game_state/tictactoe.dart';
import 'package:mcts_tictactoe/small_classes/cords.dart';

BlocListener<GameBloc, GameState> computerPlayer(Duration stallLength) {
  return BlocListener<GameBloc, GameState>(
      listenWhen: (GameState previous, GameState current) {
    return (current is AwaitingComputerMove);
  }, listener: (BuildContext context, GameState state) {
    TicTacToe _game = TicTacToe.from(state.game);
    Future<Cords> mctsProgress = _game.makeMCTS();
    Timer(stallLength, () {
      mctsProgress.then(
          (Cords move) => context.read<GameBloc>().add(ComputerMoveMade(move)));
    });
  });
}
