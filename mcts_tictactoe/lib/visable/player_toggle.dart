import 'package:flutter/material.dart';
import '../player_enum.dart';
import '../icons/robot.dart';
import '../bloc/game_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerToggle extends StatelessWidget {
  final PlayerType player;

  const PlayerToggle(this.player, { Key? key }) : super(key: key);

  static double buttonSize = 90;

  static Map<PlayerType, Color> colors = {
    PlayerType.X: Colors.red,
    PlayerType.O: Colors.blue,
  };
  static Map<PlayerType, String> playerSymbols = {
    PlayerType.X: 'X',
    PlayerType.O: 'O',
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
              child: PlayerToggle.icons[state.humanPlayers[player]!],
              onPressed: () {
                context.read<GameBloc>().add(PlayerTypeToggled(player));
              },
            ),
          ],
        ),
      );
    }
    );
  }
}
