import 'dart:async';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:mcts_tictactoe/game_state/tictactoe.dart';
import '../small_classes/cords.dart';
import '../small_classes/tile_states.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  TicTacToe game;
  bool visualizeMCTS = false;
  int compPauseDurration;

  StreamSubscription<int>? mctsProgress;

  GameBloc({required this.game, this.compPauseDurration = 3000})
      : super(GameInitial(game)) {
    on<MoveAttempted>(_onMoveAttempted);
    on<PlayerTypeToggled>(_onPlayerTypeToggled);
  }

  @override
  Future<void> close() {
    mctsProgress?.cancel();
    return super.close();
  }

  void _determineNextAction(Emitter<GameState> emit) async {
    if (game.winner != null) {
      emit(GameOver(game));
      return;
    }
    if (game.humansTurn) {
      emit(GameInProgress(game));
      return;
    }

    return _determineNextAction(emit);
  }

  void _onMoveAttempted(MoveAttempted event, Emitter<GameState> emit) {
    if (game.winner != null) {
      game.reset();
      emit(GameInitial(game));
      return;
    }
    if (game.humansTurn) {
      game.makeMove(event.move!);
      _determineNextAction(emit);
      return;
    }
  }

  void _onPlayerTypeToggled(PlayerTypeToggled event, Emitter<GameState> emit) {
    game.togglePlayer(event.toggledPlayer);
    _determineNextAction(emit);
    return;
  }
}
