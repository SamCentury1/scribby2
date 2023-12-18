// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/menu_screen/menu_screen.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: I,
      //   title: const Text(
      //     "Game Over"
      //   ),
      // ),
      body: Consumer<GamePlayState>(
        builder: (context, gamePlayState, child) {
          return SafeArea(
            child: Column(
              children: [
                const Text("Game Summary"),
                Text("${gamePlayState.summaryData['points']} points"),
                ElevatedButton(
                  onPressed: () {
                    gamePlayState.endGame();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MenuScreen()
                      )
                    );                     
                  }, 
                  child: const Text("Main Menu")
                )
              ],
            )
          );
        },
      ),
    );
  }
}