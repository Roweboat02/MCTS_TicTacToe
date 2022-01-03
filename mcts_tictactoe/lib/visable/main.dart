import 'package:flutter/material.dart';
import 'package:mcts_tictactoe/enums/board_states.dart';
import 'player_toggle.dart';
import 'board.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../tictactoe/tictactoe.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const int boardLen = 3;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(game: TicTacToe(boardLen)),
      child: const TicTacToePage(boardLen),
    );
  }
}

class TicTacToePage extends StatelessWidget {
  final int boardLen;
  const TicTacToePage(this.boardLen, {Key? key}) : super(key: key);

  static Color? backgroundFromWinner(TileState? winner) {
    return {
      TileState.O: Colors.blue[800],
      TileState.X: Colors.red[800],
      null: null,
      TileState.draw: Colors.green,
    }[winner];
  }

  static Color backgroundfromTurn(TileState turn) {
    return {
      TileState.O: Colors.blue,
      TileState.X: Colors.red,
    }[turn]!;
  }

  static backgroundFromGame(TicTacToe game) {
    return backgroundFromWinner(game.winner) ??
        backgroundfromTurn(game.turnsTile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(buildWhen: (previousState, state) {
      return previousState.runtimeType != state.runtimeType;
    }, builder: (context, state) {
      return Scaffold(
          backgroundColor: backgroundFromGame(state.game),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Board(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  PlayerToggle(TileState.O),
                  PlayerToggle(TileState.X)
                ],
              )
            ],
          ));
    });
  }
}
