// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_board.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_overlay.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_random_letters.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_scoreboard.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_components/tutorial_time_widget.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialScreen1 extends StatefulWidget {
  const TutorialScreen1({super.key});

  @override
  State<TutorialScreen1> createState() => _TutorialScreen1State();
}

class _TutorialScreen1State extends State<TutorialScreen1> {
  @override
  Widget build(BuildContext context) {
    // final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    final SettingsController settings =
        Provider.of<SettingsController>(context, listen: false);
    // final Palette palette = Provider.of<Palette>(context, listen: false);
    final ColorPalette palette =
        Provider.of<ColorPalette>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: palette.optionButtonBgColor,
          title: Row(
            children: [
              TextButton(
                child: Text(
                  'Skip Tutorial',
                  style: TextStyle(color: palette.textColor2),
                ),
                onPressed: () {
                  debugPrint('skip this tutorial');
                },
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                color: palette.optionButtonBgColor,
                onPressed: () {
                  print("last screen");
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: palette.textColor2,
                ),
              ),
              IconButton(
                color: palette.optionButtonBgColor,
                onPressed: () {
                  print("next screen");
                },
                icon: Icon(Icons.arrow_forward, color: palette.textColor2),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              color: palette.screenBackgroundColor,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                child: Column(
                  children: [
                    TutorialTimerWidget(),
                    TutorialScoreboard(),
                    Expanded(child: SizedBox()),
                    TutorialRandomLetters(),
                    Expanded(child: SizedBox()),
                    TutorialBoard(),
                    Expanded(child: SizedBox())
                  ],
                ),
              ),
            ),
            const TutorialOverlay(),
          ],
        ),
      ),
    );
  }
}
