import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/bonus_icons.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/painters/tile_painters.dart';
import 'dart:ui' as ui;

import 'package:scribby_flutter_v2/screens/instructions_screen/components/instructions_column.dart';

class InstructionsView extends StatefulWidget {
  final VoidCallback onBack;
  const InstructionsView({
    super.key,
    required this.onBack
  });

  @override
  State<InstructionsView> createState() => _InstructionsViewState();
}

class _InstructionsViewState extends State<InstructionsView> {


  @override
  Widget build(BuildContext context) {
    /// Builds the Instructions view with an independent `onBack` callback
    SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    ColorPalette palette = Provider.of<ColorPalette>(context,listen: false);

    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double scalor = gamePlayState.scalor;

        return SizedBox(
          height: gamePlayState.elementSizes["screenSize"].height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
            child: Column(
              key: const ValueKey('instructionsView'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150 * scalor,
                  child: Align(
                    alignment: Alignment.centerLeft,
                        child: Row(
                          // alignment: Alignment.centerLeft,
                          children: [
                            IconButton(
                              onPressed: widget.onBack, 
                              icon: Icon(Icons.arrow_back, color: Colors.white ),
                              iconSize: 34 * scalor,
                            ),
                            Text("Instructions", style: TextStyle(color: Colors.white, fontSize: 26*scalor),)
                          ] 
                        ),
                  ),
                ),

                InstructionsColumn(
                  scalor: scalor, 
                  screenWidth: gamePlayState.elementSizes["screenSize"].width, 
                  settingsState: settingsState,
                  palette: palette,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
