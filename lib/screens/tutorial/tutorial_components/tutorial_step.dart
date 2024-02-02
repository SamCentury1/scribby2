import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';
import 'package:scribby_flutter_v2/utils/states.dart';

class TutorialStep extends StatefulWidget {
  const TutorialStep({super.key});

  @override
  State<TutorialStep> createState() => _TutorialStepState();
}

class _TutorialStepState extends State<TutorialStep>
    with TickerProviderStateMixin {
  late AnimationState _animationState;
  late ColorPalette palette;

  late Animation<Offset> _slideEnterAnimation;
  late AnimationController _slideEnterController;

  late Animation<Offset> _slideExitAnimation;
  late AnimationController _slideExitController;

  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    _animationState = Provider.of<AnimationState>(context, listen: false);
    _animationState.addListener(_handleAnimationStateChange);
    initializeAnimations();
  }

  void _handleAnimationStateChange() {
    if (_animationState.shouldRunTutorialNextStepAnimation) {
      _runSlideAnimations();
    }

    if (_animationState.shouldRunTutorialPreviousStepAnimation) {
      _runReverseAnimations();
    }
  }

  void _runSlideAnimations() {
    _slideEnterController.reset();
    _slideExitController.reset();

    _slideEnterController.forward();
    _slideExitController.forward();
  }

  void _runReverseAnimations() {
    _slideEnterController.reverse();
    _slideExitController.reverse();
  }

  void initializeAnimations() {
    _slideEnterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideEnterAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(_slideEnterController);

    _slideEnterController.forward();

    _slideExitController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _slideExitAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-2.0, 0.0),
    ).animate(_slideExitController);

    _slideExitController.forward();
  }

  Map<String, dynamic> getStepDetails(
      TutorialState tutorialState, int position) {
    late Map<String, dynamic> stepDetails = {};
    if (tutorialState.sequenceStep + position < 0) {
      stepDetails = tutorialDetails.firstWhere(
          (element) => element['step'] == (tutorialState.sequenceStep));
    } else {
      stepDetails = tutorialDetails.firstWhere((element) =>
          element['step'] == (tutorialState.sequenceStep + position));
    }
    return stepDetails;
  }

  void goToNextStep(
      TutorialState tutorialState, AnimationState animationState) {
    late Map<String, dynamic> currentStep =
        TutorialHelpers().getCurrentStep2(tutorialState);
    // if (currentStep['isGameStarted']) {

    //   if (currentStep['isGameEnded']) {
    //     tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);

    //   } else {

    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
    animationState.setShouldRunTutorialNextStepAnimation(true);
    animationState.setShouldRunTutorialNextStepAnimation(false);
    //   }
    // } else {
    //   tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
    // }

    // tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
    // print(tutorialState.sequenceStep);
    // animationState.setShouldRunTutorialNextStepAnimation(true);
    // // animationState.setShouldRunTutorialNextStepExitAnimation(true);

    // animationState.setShouldRunTutorialNextStepAnimation(false);
    // // animationState.setShouldRunTutorialNextStepExitAnimation(false);
  }

  @override
  void dispose() {
    _slideEnterController.dispose();
    _slideExitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {
        // Map<String,dynamic> currentStep = getStepDetails(tutorialState, 0);
        // Map<String,dynamic> previousStep = getStepDetails(tutorialState, -1);

        Map<String, dynamic> currentStep =
            TutorialHelpers().getCurrentStep2(tutorialState);
        Map<String, dynamic> previousStep =
            TutorialHelpers().getPreviousStep2(tutorialState);
        return Container(
          width: double.infinity,
          height: 100,
          color: palette.screenBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const Divider(),
              // tutorialState.sequenceStep < 3 ? const SizedBox() :
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Flexible(
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _slideEnterAnimation,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _slideEnterAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    currentStep['text'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: palette.textColor2),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _slideExitAnimation,
                            builder: (context, child) {
                              return SlideTransition(
                                position: _slideExitAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    currentStep['text'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: palette.textColor2),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: !currentStep['complete']
                          ? const SizedBox()
                          : TextButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: palette.optionButtonBgColor,
                              ),
                              onPressed: () {
                                if (currentStep['step'] == 21) {
                                  tutorialState.setSequenceStep(tutorialState.sequenceStep+15);
                                } else {
                                  goToNextStep(tutorialState, _animationState);
                                }
                              },
                              child: Text(
                                "next",
                                style: TextStyle(
                                    fontSize: 18, color: palette.textColor2),
                              ),
                            ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
