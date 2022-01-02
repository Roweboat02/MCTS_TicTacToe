import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mcts_tictactoe/visable/tile.dart';
import 'package:meta/meta.dart';
import 'package:mcts_tictactoe/player_enum.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<GameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
