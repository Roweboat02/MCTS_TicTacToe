import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcts_tictactoe/bloc/game_bloc.dart';
import 'package:mcts_tictactoe/enums/board_states.dart';

class AnnouncerText extends StatelessWidget {
  const AnnouncerText({Key? key}) : super(key: key);

  String determineText(GameState state) {
    late String text;
    if (state is GameOver) {
      text = 'Game Over! ';
      if (state.winner != TileState.draw) {
        text += '${state.winner == TileState.X ? 'X' : 'O'} Won!';
      } else {
        text += 'Draw!';
      }
    } else if (state is GameInitial || state is GameInProgress) {
      text = '${state.game.turn ? 'O' : 'X'}\'s Turn';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Text(
        determineText(state),
        style: TextStyle(
            fontSize: 75.0, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}
