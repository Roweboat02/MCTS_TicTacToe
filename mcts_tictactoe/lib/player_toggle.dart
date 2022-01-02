import 'package:flutter/material.dart';
import 'robot.dart';

class PlayerToggle extends StatefulWidget {
  const PlayerToggle({ Key? key, required this.color, required this.playerSymbol }) : super(key: key);

  final Color color;
  final String playerSymbol;
  static double buttonSize = 90;

  @override
  _PlayerToggleState createState() => _PlayerToggleState();
}

class _PlayerToggleState extends State<PlayerToggle> {
  bool human = true;
  get intHuman => human?1:0;

  List<Icon> icons = [
    Icon(MyFlutterApp.robot),
    Icon(Icons.accessibility)];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 4.0),
      child: Column(
        children: [
          Text(
            widget.playerSymbol,
            style: TextStyle(fontSize:60, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(PlayerToggle.buttonSize, PlayerToggle.buttonSize),
              primary: widget.color,
            ),
            child: icons[intHuman],
            onPressed: (){
              setState((){human=!human;});
            },
          ),
        ],
      ),
    );
    
  }
}