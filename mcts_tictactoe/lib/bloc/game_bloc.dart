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
    on<HumanMoveMade>(_onMoveAttempted);
    on<ComputerMoveMade>(_onMoveAttempted);
    on<PlayerTypeToggled>(_onPlayerTypeToggled);
  }

  @override
  Future<void> close() {
    mctsProgress?.cancel();
    return super.close();
  }

  void _determineNextAction(Emitter<GameState> emit) async {
    if (game.winner != null) {
      emit(GameOver(TicTacToe.from(game)));
      return;
    }
    if (game.isTurnHumans) {
      emit(AwaitingHumanMove(TicTacToe.from(game)));
      return;
    } else {
      emit(AwaitingComputerMove(TicTacToe.from(game)));
      return;
    }
  }

  void _onMoveAttempted(GameEvent event, Emitter<GameState> emit) {
    if (game.winner != null) {
      game.reset();
      return _determineNextAction(emit);
    }
    if ((game.isTurnHumans && event is HumanMoveMade)) {
      game.makeMove(event.move);
      return _determineNextAction(emit);
    } else if (!game.isTurnHumans && event is ComputerMoveMade) {
      //Kept separate from HumanMadeMove as language server
      //failed to understand event would have a move member w/ an or statement.
      game.makeMove(event.move);
      return _determineNextAction(emit);
    }
  }

  void _onPlayerTypeToggled(PlayerTypeToggled event, Emitter<GameState> emit) {
    game.togglePlayer(event.toggledPlayer);
    _determineNextAction(emit);
    return;
  }
}
