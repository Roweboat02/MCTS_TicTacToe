import 'package:mcts_tictactoe/mcts/tree_node.dart';
import '../small_classes/cords.dart';
import 'package:mcts_tictactoe/game_state/tictactoe.dart';
import 'package:mcts_tictactoe/small_classes/result.dart';

Result mcts(TreeNode node, {int depth = 0}) {
  depth++;
  late Result result;
  if (node.winner != null) {
    result = Result(node.winner!, depth);
  } else if (!node.visited) {
    node.populate();
    result = node.rollout(depth);
  } else {
    result = mcts(node.child, depth: depth);
  }

  node.updateScore(result);
  return result;
}

Cords findBestMove(TicTacToe game, int simulations) {
  TreeNode node = TreeNode(game, null);
  while (simulations > 0) {
    simulations--;
    mcts(node, depth: 0);
  }
  // return node.ucb().move!;
  return (node.children!..sort((a, b) => a.score.compareTo(b.score)))
      .first
      .move!;
}
