import 'package:flutter/material.dart';
import 'package:mcts_tictactoe/small_classes/tile_states.dart';
import 'package:mcts_tictactoe/ui_elements/player_toggle.dart';
import 'bloc/bloc_listener.dart';
import 'bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_state/tictactoe.dart';
import 'ui_elements/announcer_text.dart';
import 'ui_elements/board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const int boardLen = 3;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(game: TicTacToe(boardLen)),
      child:
          ComputerPlayer(TicTacToePage(boardLen), Duration(milliseconds: 1500)),
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
      TileState.O: const Color(0xFF0D47A1),
      TileState.X: const Color(0xFFB71C1C),
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
                children: const <Widget>[
                  AnnouncerText(),
                  Board(),
                  BothPlayerToggles(),
                ],
              )));
    });
  }
}
