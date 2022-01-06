import 'dart:math';

import 'package:mcts_tictactoe/game_state/tictactoe.dart';
import 'package:mcts_tictactoe/small_classes/cords.dart';
import 'package:mcts_tictactoe/small_classes/result.dart';
import 'package:mcts_tictactoe/small_classes/tile_states.dart';

class TreeNode {
  // Inputted members
  final TicTacToe game;

  // Optional members
  final Cords? move;

  // Internally managed members
  bool visited = false;
  List<TreeNode>? children;
  int? _unvisitedIndex;

  int visits = 0;
  double score = 0;

  // Constructors
  TreeNode(
    TicTacToe gameState,
    this.move,
  ) : this.game = TicTacToe.from(gameState) {
    if (move != null) {
      this.game.makeMove(move!);
    }
  }

  // Getters
  TileState? get winner => game.winner;

  TreeNode get child {
    // The child that should be used next in an operation
    for (TreeNode _child in children!) {
      if (!_child.visited) {
        return _child;
      }
    }
    return this.ucb();
  }

  // MCTS functions
  void populate() {
    visited = true;
    children = game
        .availableMoves()
        .map((possibleMove) => TreeNode(game, possibleMove))
        .toList();
    _unvisitedIndex = children!.length;
  }

  TreeNode ucb({cConst = 1.41}) {
    double? bestScore;
    TreeNode? bestChild;

    late double _score;
    for (TreeNode _child in children!) {
      _score = _child.score / _child.visits +
          cConst * sqrt(log(this.visits) / _child.visits);
      if (bestScore == null || _score > bestScore) {
        bestScore = _score;
        bestChild = _child;
      }
    }

    return bestChild!;
  }

  void updateScore(Result result) {
    visits++;
    if (result.winner == TileState.draw) {
      score += 0.5;
      return;
    }
    if (_wonOrLost(result.winner)) {
      score += 5;
      return;
    } else {
      score -= (5 + (1000000 / pow(result.depth, 15)));
    }
  }

  Result rollout(int depth) {
    TicTacToe _game = TicTacToe.from(game);

    while (_game.winner == null) {
      depth++;
      _game.makeArbitraryMove();
    }
    return Result(_game.winner!, depth);
  }

  int _increaseOrDecrease(TileState outcome) {
    return (TicTacToe.boolToBoardState(game.turn) == outcome) ? 1 : -1;
  }

  bool _wonOrLost(TileState outcome) {
    return TicTacToe.boolToBoardState(game.turn) == outcome;
  }
}
