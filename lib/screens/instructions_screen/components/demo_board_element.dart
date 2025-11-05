
import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/demo_board_painter.dart';

class DemoBoardElement extends StatelessWidget {
  final SettingsState settingsState;
  final int currentStep;
  final double boardSize;
  final int ellapsedTimeMs;
  final double tilePlacedProgress;
  final double scalor;
  final ColorPalette palette;
  const DemoBoardElement({
    super.key,
    required this.settingsState,
    required this.currentStep,
    required this.boardSize,
    required this.ellapsedTimeMs,
    required this.tilePlacedProgress,
    required this.scalor,
    required this.palette
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0,5*scalor,0.0,40*scalor),
      child: SizedBox(
        width: boardSize,
        height: boardSize, 
        child: CustomPaint(
          painter:DemoBoardPainter(
            settingsState:settingsState,
            step: currentStep,
            elapsedTime: ellapsedTimeMs,
            tilePlacementProgress: tilePlacedProgress,
            palette: palette
          )
        ),
      ),
    );

  }
}


