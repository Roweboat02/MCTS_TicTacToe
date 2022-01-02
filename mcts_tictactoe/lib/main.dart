import 'package:flutter/material.dart';
import 'visable/player_toggle.dart';
import 'visable/board.dart';
import 'bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main(List<String> args) {
  runApp( MyApp() );
}

class MyApp extends StatelessWidget {
  static final String title = 'Tic Tac Toe';

  List<PlayerToggle> playerToggles = [
    PlayerToggle(color: Colors.blue, playerSymbol: 'O',),
    PlayerToggle(color: Colors.red, playerSymbol: 'X')
  ];

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => GameBloc(),
      child: const TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatelessWidget {
  const TicTacToePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}