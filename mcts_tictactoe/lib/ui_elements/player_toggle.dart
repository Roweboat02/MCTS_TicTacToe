import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';

import '../small_classes/tile_states.dart';
import '../icons/robot.dart';

class PlayerToggle extends StatelessWidget {
  /// A PlayerToggle is an ElevatedButton which is the color assosiated with
  /// it's given [player], and text above it which shows that [player]'s symbol.
  ///
  /// Pressing it switches between an icon for a robot and a person,
  /// it will then raise an event to the Bloc to switch [player]'s player type.

  final TileState player;

  const PlayerToggle(this.player, {Key? key}) : super(key: key);

  static double buttonSize = 90;

  static Color colorFromTileState(TileState player) {
    return {
      TileState.X: Colors.red,
      TileState.O: Colors.blue,
    }[player]!;
  }

  static String symbolFromTileState(TileState player) {
    return {
      TileState.X: 'X',
      TileState.O: 'O',
    }[player]!;
  }

  static Icon iconFromBool(bool turn) {
    return {
      false: const Icon(MyFlutterApp.robot, size: 50.0),
      true: const Icon(Icons.accessibility, size: 50.0),
    }[turn]!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              PlayerToggle.symbolFromTileState(player),
              style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize:
                    Size(PlayerToggle.buttonSize, PlayerToggle.buttonSize),
                primary: PlayerToggle.colorFromTileState(player),
              ),
              child: PlayerToggle.iconFromBool(state.players[player]!),
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

class BothPlayerToggles extends StatelessWidget {
  const BothPlayerToggles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [PlayerToggle(TileState.O), PlayerToggle(TileState.X)],
    );
  }
}
