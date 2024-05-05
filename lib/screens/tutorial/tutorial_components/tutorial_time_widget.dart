import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialTimerWidget extends StatefulWidget {
  final Animation animation;
  final String language;
  const TutorialTimerWidget({
    super.key,
    required this.animation,
    required this.language,
  });

  @override
  State<TutorialTimerWidget> createState() => _TutorialTimerWidgetState();
}

class _TutorialTimerWidgetState extends State<TutorialTimerWidget>
    with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

        final Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);

        return Row(
          children: [
            Text(
              "${Helpers().translateText(widget.language, "Level",)} 1",
              style: TextStyle(
                fontSize: (22 * settingsState.sizeFactor),
                color: palette.textColor1,
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ), // Spacer(),
            AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                return Opacity(
                  opacity: currentStep['target'] == 'timer' ?  widget.animation.value : 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        Text(
                          "00:00",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (22 * settingsState.sizeFactor),
                            color: palette.textColor1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.timer,
                          color: palette.textColor1,
                          size: 22*settingsState.sizeFactor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
