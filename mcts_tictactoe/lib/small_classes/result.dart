import 'package:mcts_tictactoe/small_classes/tile_states.dart';

class Result {
  int depth;
  TileState winner;
  Result(this.winner, this.depth);
}
