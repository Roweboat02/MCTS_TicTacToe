import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {

  static const int X = 0;
  static const int O = 1;
  static const int empty = 2;





  static List<Color> backgroundColors = [
    Colors.red[900]!,
    Colors.blue[900]!,
    Colors.green[800]!,

  ];

  static const int boardLen = 3;
  static const double tileSize = 100;

  const GameBoard({ Key? key }) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // get intTurn=>(turn? 1:0);

  // bool _isOver = false;
  // int _winner = 0;
  // get backgroudIndex{
  //   if (_isOver){return _winner;}
  //   else {return intTurn;}
  // }

  bool turn = true;
  late List<List<int>> board;

  @override
  void initState() {
    setEmptyBoard();
    super.initState();
  }

  List<List<int>> setEmptyBoard() => board = List.generate(GameBoard.boardLen, (_) => List.generate(GameBoard.boardLen, (_) => GameBoard.empty));

  int checkForWin(){
    late int leftDiag;
    late int rightDiag;

    for (int turn in [GameBoard.X, GameBoard.O]){
      rightDiag = leftDiag = 0;

      for (int k=0;k<GameBoard.boardLen;k++){
        if (board[k][k] == turn){rightDiag++;}
        if (board[k][(GameBoard.boardLen-1)-k] == turn){leftDiag++;} // check if tiles on diag are turn

        if (board[k].every((element) => element==turn)){return turn;}  // check each row
        if (board.every((element) => element[k]==turn)){return turn;}  // check each col
      }
      if ((leftDiag==3)||(rightDiag==3)) {return turn;}
    }
    return GameBoard.empty;
  }

  bool checkForTie() => board.every((values)=> values.every((value) => value!=GameBoard.empty));

  Widget createTile(int i, int j){
    final value = board[i][j];
    final color = GameBoard.tileColors[value];
    final symbol = GameBoard.tileSymbols[value];

    return 
  }

  void selectTile(int i, int j) => (board[i][j] == GameBoard.empty)? makeMove(i,j) : alreadySelected(i,j);
  

  void makeMove(int i, int j){
    setState((){
      board[i][j] = intTurn;
      turn = !turn;
    });
    if (checkForTie()){
      setState(() {
        _winner = GameBoard.empty;
        _isOver = true;
        onEnd('Game ended in a draw');
      });
    }
    else {
      int result = checkForWin();
      if (result != GameBoard.empty){
        setState(() {
          _winner = result;
          _isOver = true;
          onEnd('${GameBoard.tileSymbols[result]} Won!');
        });
      } 
    }
  }

  List<List<int>> availableMove(){
    List<List<int>> moves = [];
    for (int i=0; i<GameBoard.boardLen; i++){
      for (int j=0; j<GameBoard.boardLen; j++){
        moves.add([i,j]..length=2);
      }
    }
    return moves;
  }
  
  void alreadySelected(int i, int j){
    return;
  }

  Widget createBoard(){
    List<Widget> colChildren = [];

    for (int i=0; i<GameBoard.boardLen; i++){
      List<Widget> rowChildren = [];

      for (int j=0; j<GameBoard.boardLen; j++){
        rowChildren.add(createTile(i, j));
      }

      colChildren.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: rowChildren,));
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: colChildren,);
  }

  Future onEnd(String title){
    return showDialog(
      context: context,
      builder: (context){
          return AlertDialog(
            title: Text(title),
            content: Text('Restart?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    setEmptyBoard();
                    _isOver=false;
                  });
                  Navigator.of(context).pop();},
                child: Text('OK!'),
              )
            ],
        );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GameBoard.backgroundColors[backgroudIndex],
      child: createBoard(),
    );
  }
}