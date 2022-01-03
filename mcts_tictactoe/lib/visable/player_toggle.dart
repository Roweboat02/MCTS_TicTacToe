import 'package:flutter/material.dart';
import '../enums/board_states.dart';
import '../icons/robot.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerToggle extends StatelessWidget {
  final TileState player;

  const PlayerToggle(this.player, {Key? key}) : super(key: key);

  static double buttonSize = 90;

  static Map<TileState, Color> colors = {
    TileState.X: Colors.red,
    TileState.O: Colors.blue,
  };
  static Map<TileState, String> playerSymbols = {
    TileState.X: 'X',
    TileState.O: 'O',
  };
  static Map<bool, Icon> icons = {
    false: const Icon(MyFlutterApp.robot),
    true: const Icon(Icons.accessibility),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(buildWhen: (previousState, state) {
      return previousState.runtimeType != state.runtimeType;
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        child: Column(
          children: [
            Text(
              PlayerToggle.playerSymbols[player]!,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize:
                    Size(PlayerToggle.buttonSize, PlayerToggle.buttonSize),
                primary: PlayerToggle.colors[player],
              ),
              child: PlayerToggle.icons[state.players[player]!],
              onPressed: () {
                context.read<GameBloc>().add(PlayerTypeToggled(player));
              },
            ),
          ],
        ),
      );
    });
  }
}
