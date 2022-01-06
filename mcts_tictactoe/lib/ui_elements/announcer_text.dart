import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mcts_tictactoe/bloc/game_bloc.dart';
import 'package:mcts_tictactoe/small_classes/tile_states.dart';

class AnnouncerText extends StatelessWidget {
  const AnnouncerText({Key? key}) : super(key: key);

  String _determineText(GameState state) {
    switch (state.runtimeType) {
      case CompMakingMove:
        return '...';
      case GameOver:
        String text = 'Game Over!';
        if (state.game.winner == TileState.draw) {
          return text + ' Draw!';
        } else {
          return text + '${state.game.winner == TileState.X ? 'X' : 'O'} Won!';
        }
      case GameInitial:
      case AwaitingHumanMove:
        return '${state.game.turn ? 'O' : 'X'}\'s Turn';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Text(
        _determineText(state),
        style: const TextStyle(
            fontSize: 75.0, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}
