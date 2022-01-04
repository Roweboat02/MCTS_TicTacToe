import 'package:flutter/material.dart';
import 'package:mcts_tictactoe/enums/tile_states.dart';
import 'package:mcts_tictactoe/visable/announcer_text.dart';
import 'visable/player_toggle.dart';
import 'visable/board.dart';
import 'bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tictactoe/tictactoe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const int boardLen = 3;

  const MyApp({Key? key}) : super(key: key);

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
      TileState.draw: Colors.green[700],
    }[winner];
  }

  static Color backgroundfromTurn(TileState turn) {
    return {
      TileState.O: Color(0xFF0D47A1),
      TileState.X: Color(0xFFB71C1C),
    }[turn]!;
  }

  static backgroundFromGame(TicTacToe game) {
    return backgroundFromWinner(game.winner) ??
        backgroundfromTurn(game.turnsTile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return MaterialApp(
          home: Scaffold(
              backgroundColor: backgroundFromGame(state.game),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AnnouncerText(),
                  const Board(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      PlayerToggle(TileState.O),
                      PlayerToggle(TileState.X)
                    ],
                  )
                ],
              )));
    });
  }
}
