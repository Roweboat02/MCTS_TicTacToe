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
    if (_unvisitedIndex! > 0) {
      _unvisitedIndex = _unvisitedIndex! - 1;
      return children![_unvisitedIndex!];
    } else {
      return this.ucb();
    }
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
      score += 1;
      return;
    }
    score +=
        _increaseOrDecrease(result.winner) * (2 + (6 / (pow(result.depth, 2))));
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
}
