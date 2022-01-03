import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mcts_tictactoe/visable/tile.dart';
import 'package:meta/meta.dart';
import 'package:mcts_tictactoe/enums/board_states.dart';
import '../tictactoe/tictactoe.dart';
import 'dart:async';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  TicTacToe game;
  bool visualizeMCTS = false;

  GameBloc({required this.game}) : super(GameInitial(game)) {
    on<GameEvent>((event, emit) {});
  }

  @override
  Future<void> close() {
    return super.close();
  }

  _onMoveAttempted(MoveAttempted event, Emitter<GameState> emit) {
    if (game.humansTurn) {
      game.makeMove(event.i!, event.j!);
      if (game.winner == null) {
        emit(GameInProgress(game));
      } else {
        emit(GameOver(game));
      }
    } else if (!visualizeMCTS) {
      game.makeMCTS();
      _onMoveAttempted(event, emit);
    }
  }

  _onPlayerTypeToggled(PlayerTypeToggled event, Emitter<GameState> emit) {
    game.togglePlayer(event.toggledPlayer);
    if (!game.humansTurn && game.winner == null) {
      if (!visualizeMCTS) {
        _onMoveAttempted(MoveAttempted(), emit);
      }
    }
  }
}
