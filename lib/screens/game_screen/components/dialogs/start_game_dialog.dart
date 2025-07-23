import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'dart:ui' as ui;

import 'package:scribby_flutter_v2/settings/settings.dart';

class StartGameOverlay extends StatefulWidget {
  const StartGameOverlay({super.key});

  @override
  State<StartGameOverlay> createState() => _StartGameOverlayState();
}

class _StartGameOverlayState extends State<StartGameOverlay> {
  @override
  Widget build(BuildContext context) {
    SettingsController settings = Provider.of<SettingsController>(context,listen: false);
    final double scalor = Helpers().getScalor(settings);
    return Consumer<GamePlayState>(
      builder:(context, gamePlayState, child) {
        
        if (gamePlayState.isGameStarted) {
          return SizedBox();
        } else {
          return Positioned.fill(
            child: ClipRRect(
              child: GestureDetector(
                onTap: () {
                  bool isTimeToPlace = gamePlayState.gameParameters["timeToPlace"]!=null;
                  if (isTimeToPlace) {
                    gamePlayState.setStopWatchLimit(6 * 1000);
                    gamePlayState.restartStopWatchTimer();
                  }
                  if (gamePlayState.countDownDuration != null ) {
                    gamePlayState.startCountDown();
                  }
                  gamePlayState.startTimer();
                  gamePlayState.setIsGameStarted(true);
                },
                child: Container(
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: 8.0,
                          sigmaY: 8.0,
                        ),

                          child: Container(

                          )
                      ),
                      Container(
                        
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: const ui.Color.fromARGB(13, 85, 85, 85),blurRadius: 30.0)
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const ui.Color.fromARGB(128, 228, 228, 228),
                              const ui.Color.fromARGB(51, 212, 212, 212)
                            ],
                            stops:[0.0,1.0]
                          )
                        ),
                        child: Center(
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 43*scalor
                            ),
                            child: Text(
                              "Tap to Start"
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );        
        }
      }, 
    );
  }
}