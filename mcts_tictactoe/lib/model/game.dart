class Game {
  bool turn = true;
  List<bool> players = [false, false]..length=2;
  bool isOver = false;
  int winner = 0;
  List<List<int>>? _board;

  get board => _board ??= emptyBoard;

  get emptyBoard => List.generate(boardLen, (_) => List.generate(boardLen, (_) => empty));

  List<List<int>> setEmptyBoard() => _board = emptyBoard;

  int checkForWin(){
    late int leftDiag;
    late int rightDiag;

    for (int turn in [X, O]){
      rightDiag = leftDiag = 0;

      for (int k=0;k<boardLen;k++){
        if (board[k][k] == turn){rightDiag++;}
        if (board[k][(boardLen-1)-k] == turn){leftDiag++;} // check if tiles on diag are turn

        if (board[k].every((element) => element==turn)){return turn;}  // check each row
        if (board.every((element) => element[k]==turn)){return turn;}  // check each col
      }
      if ((leftDiag==3)||(rightDiag==3)) {return turn;}
    }
    return empty;
  }

  bool checkForTie() => board.every((values)=> values.every((value) => value!=empty));

  List<List<int>> availableMove(){
    List<List<int>> moves = [];
    for (int i=0; i<boardLen; i++){
      for (int j=0; j<boardLen; j++){
        moves.add([i,j]..length=2);
      }
    }
    return moves;
  }
}