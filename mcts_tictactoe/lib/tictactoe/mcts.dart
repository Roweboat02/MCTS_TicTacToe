import 'package:mcts_tictactoe/enums/board_states.dart';
import 'package:mcts_tictactoe/tictactoe/tictactoe.dart';

import 'dart:math';

class Result {
  int depth;
  TileState winner;
  Result(this.winner, this.depth);
}

Result mcts(TreeNode node, {int depth = 0}) {
  depth++;
  late Result result;
  if (node.winner != null) {
    result = Result(node.winner!, depth);
  } else if (!node.populated) {
    node.populate();
    result = node.rollout(depth);
  } else {
    result = mcts(node.child, depth: depth);
  }

  node.updateScore(result);
  return result;
}

List<int> findBestMove(TicTacToe game, int simulations) {
  TreeNode node = TreeNode(game, null);
  while (simulations > 0) {
    simulations--;
    mcts(node);
  }
  return node.ucb().move!;
}

class TreeNode {
  final TicTacToe game;
  final List<int>? move;
  bool populated = false;
  List<TreeNode>? children;
  int? _unvisitedIndex;

  int visits = 0;
  double score = 0;

  TreeNode(
    TicTacToe game,
    this.move,
  ) : this.game = TicTacToe.from(game) {
    if (move != null) {
      game.makeMove(move![0], move![1]);
    }
  }

  TileState? get winner => game.winner;

  TreeNode get child {
    if (_unvisitedIndex! > 0) {
      _unvisitedIndex = _unvisitedIndex! - 1;
      return children![_unvisitedIndex!];
    } else {
      return this.ucb();
    }
  }

  void populate() {
    populated = true;
    children = game
        .availableMoves()
        .map((possibleMove) => TreeNode(game, possibleMove))
        .toList();
    _unvisitedIndex = children!.length;
  }

  TreeNode ucb({cConst = 1.41}) {
    List<double> ucbValues = children!.map((_child) {
      return _child.score / _child.visits +
          cConst * sqrt(log(this.visits) / _child.visits);
    }).toList();

    double greatestVal = ucbValues.first;
    for (double val in ucbValues) {
      if (val > greatestVal) {
        greatestVal = val;
      }
    }

    return children![ucbValues.indexOf(greatestVal)];
  }

  void updateScore(Result result) {
    visits++;

    if (result.winner == TileState.draw) {
      return;
    } else {
      score += _increaseOrDecrease(result.winner) *
          (1 + (6 / (pow(result.depth, 2))));
    }
  }

  Result rollout(int depth) {
    TicTacToe _game = TicTacToe.from(game);

    while (_game == null) {
      depth++;
      _game.makeArbitraryMove();
    }
    return Result(_game.winner!, depth);
  }

  int _increaseOrDecrease(TileState outcome) {
    return (TicTacToe.boolToBoardState[game.turn] == outcome) ? 1 : -1;
  }
}
