import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mcts_tictactoe/tictactoe/cords.dart';
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
    on<MoveAttempted>(_onMoveAttempted);
    on<PlayerTypeToggled>(_onPlayerTypeToggled);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  _onMoveAttempted(MoveAttempted event, Emitter<GameState> emit) {
    if (game.winner == null) {
      if (game.humansTurn) {
        game.makeMove(event.move!);
        if (game.winner == null) {
          emit(GameInProgress(game));
        } else {
          emit(GameOver(game));
        }
      } else if (!visualizeMCTS) {
        game.makeMCTS();
        _onMoveAttempted(event, emit);
      }
    } else {
      game.reset();
      emit(GameInitial(game));
    }
  }

  _onPlayerTypeToggled(PlayerTypeToggled event, Emitter<GameState> emit) {
    game.togglePlayer(event.toggledPlayer);
    if (!visualizeMCTS) {
      if (game.winner == null) {
        emit(GameInProgress(game));
      } else {
        emit(GameOver(game));
      }
    }
  }
}
