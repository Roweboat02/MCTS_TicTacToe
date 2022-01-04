import 'mcts.dart';
import 'tictactoe.dart';
import 'dart:math';

void main() {
  TreeNode a = TreeNode(TicTacToe(3), null);
  a.populate();
  a.rollout(1);
  double cConst = 1.41;
  print(a.children);
  print(a.children!.map((_child) {
    print(_child.visits);
    return _child.score / _child.visits +
        cConst * sqrt(log(a.visits) / _child.visits);
  }));
}
