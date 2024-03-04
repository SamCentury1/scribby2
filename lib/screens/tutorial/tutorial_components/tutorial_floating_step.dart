import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/providers/tutorial_state.dart';
import 'package:scribby_flutter_v2/screens/tutorial/tutorial_helpers.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class TutorialFloatingStep extends StatefulWidget {
  final double width;
  // final TutorialState tutorialState;
  const TutorialFloatingStep({
    required this.width,
    // required this.tutorialState,
    super.key
  });

  @override
  State<TutorialFloatingStep> createState() => _TutorialFloatingStepState();
}

class _TutorialFloatingStepState extends State<TutorialFloatingStep> with TickerProviderStateMixin {

  late AnimationState _animationState;
  late ColorPalette palette;

  late Animation<double> _slideEnterAnimation2;
  late AnimationController _slideEnterController2;  

  late Animation<double> _slideExitAnimation3;
  late AnimationController _slideExitController3;    


  late bool next = true;

  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    _animationState = Provider.of<AnimationState>(context, listen: false);
    _animationState.addListener(_handleAnimationStateChange);

    initializeAnimations(widget.width,);
    print(widget.width);
  }


  void _handleAnimationStateChange() {
    if (_animationState.shouldRunTutorialNextStepAnimation) {
      setState(() {
        next = true;
      });
      _runSlideAnimations();
    }

    if (_animationState.shouldRunTutorialPreviousStepAnimation) {
      _runSlideAnimations();
      setState(() {
        next = false;
      });
    }
  }

  void _runSlideAnimations() {
    _slideEnterController2.reset();  
    _slideExitController3.reset();    

    _slideEnterController2.forward();
    _slideExitController3.forward();    
  }


  void initializeAnimations(width) {

    _slideEnterController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideEnterAnimation2 = Tween<double>(
      begin: width,
      end: 0,
    ).animate(_slideEnterController2);
    _slideEnterController2.forward();

    _slideExitController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideExitAnimation3 = Tween<double>(
      begin: 0,
      end: width,
    ).animate(_slideExitController3);    
    _slideEnterController2.forward();    
  }  


  double getExitProperty(bool isNext, Map<String,dynamic> previousStep, Map<String,dynamic> nextStep, double height) {
    final Map<String,dynamic> step = isNext ?  previousStep : nextStep;
    return (step['height'] as double) * height;

  }  
  Map<String,dynamic> getLeftOrRightEnter(Map<String,dynamic> getStepDetails, Animation animation) {
    final double? left = getStepDetails['left'] ? (animation.value*-1) : null;
    final double? right = getStepDetails['left'] ? null : (animation.value*-1);    
    return {"left": left, "right": right};
  }

  Map<String,dynamic> getLeftOrRightExit(bool isNext, Map<String,dynamic> previousStep, Map<String,dynamic> nextStep, Animation animation) {
    final Map<String,dynamic> step = isNext ? previousStep : nextStep;
    return getLeftOrRightEnter(step,animation);
  }

  Map<String,dynamic> getTargetStepState(bool isNext,  Map<String,dynamic> previousStep,Map<String,dynamic> nextStep) {
    final Map<String,dynamic> step = isNext ?  previousStep : nextStep;
    return step;
  }

    
  @override
  Widget build(BuildContext context) {

    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

      Map<String,dynamic> previousStep = TutorialHelpers().getPreviousStep2(tutorialState);
      Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
      Map<String,dynamic> nextStep = TutorialHelpers().getNextStep2(tutorialState);


      return Stack(
        children: [
          // ================ ENTER =======================
          AnimatedBuilder(
            animation: _slideEnterAnimation2,
            builder: (context, child) {
              return 
              Positioned(
                top: MediaQuery.of(context).size.height*(currentStep['height'] as double),
                left: getLeftOrRightEnter(currentStep, _slideEnterAnimation2)['left'],
                right: getLeftOrRightEnter(currentStep, _slideEnterAnimation2)['right'],
                child: cardContainer(tutorialState,_animationState,currentStep,palette,MediaQuery.of(context).size.width*0.8, settingsState.sizeFactor),
                // child: cardContainer(
                //   next, 
                //   tutorialState,
                //   _animationState,
                //   previousStep, 
                //   currentStep, 
                //   nextStep,
                //   palette,
                //   MediaQuery.of(context).size.width*0.8
                // ),                
              );
            },
          ),

          // ================ EXIT =======================
          AnimatedBuilder(
            animation: _slideExitAnimation3,
            builder: (context, child) {
              return 
              Positioned(
                top: getExitProperty(next, previousStep, nextStep, MediaQuery.of(context).size.height),
                // top: MediaQuery.of(context).size.height*(currentStep['height'] as double),
                left: getLeftOrRightExit(next, previousStep, nextStep, _slideExitAnimation3)['left'],
                right: getLeftOrRightExit(next, previousStep, nextStep, _slideExitAnimation3)['right'],
                child: cardContainer(
                  tutorialState,
                  _animationState,
                  getTargetStepState(next,previousStep,nextStep),
                  palette,
                  MediaQuery.of(context).size.width*0.8,
                  settingsState.sizeFactor
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


Widget cardContainer(TutorialState tutorialState, AnimationState animationState, Map<String,dynamic> currentStep, ColorPalette palette, double width, double sizeFactor) {
// Widget cardContainer(
//   bool next,
//   TutorialState tutorialState, 
//   AnimationState animationState, 
//   Map<String,dynamic> previousStep,
//   Map<String,dynamic> currentStep, 
//   Map<String,dynamic> nextStep, 
//   ColorPalette palette, 
//   double width) {  

    return Container(
      width: width,//MediaQuery.of(context).size.width*0.8,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15.0,
            sigmaY: 15.0,
          ),
          child: Container(
            decoration: getBoxDecoration(currentStep),
            child:Padding(
              padding: EdgeInsets.all(10.0*sizeFactor),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: (20*sizeFactor),
                      ),
                      child: Text(
                        currentStep['text']
                      )
                    ),
                  ),
                  iconButton(tutorialState,animationState,currentStep,palette, sizeFactor),
                ],
              ),  
            ),
          ),
        ),
      ),
    );
}

BoxDecoration getBoxDecoration(Map<String,dynamic> stepDetails) {
  if (stepDetails['left']) {
    return BoxDecoration(
      color: const Color.fromARGB(255, 85, 85, 85).withOpacity(0.5),
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        )
    );     
  } else {
    return BoxDecoration(
      color: const Color.fromARGB(255, 85, 85, 85).withOpacity(0.5),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10.0),
        topLeft: Radius.circular(10.0),
        )
    );   
  }
}

Widget iconButton(TutorialState tutorialState, AnimationState animationState, Map<String,dynamic> currentStep, ColorPalette palette, double sizeFactor) {
  if (currentStep['complete']) {    
    return IconButton(
      onPressed : () {
        // if (currentStep['step'] == 21) {
        //   tutorialState.setSequenceStep(tutorialState.sequenceStep+15);
        // } else {
          tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
          animationState.setShouldRunTutorialNextStepAnimation(true);
          animationState.setShouldRunTutorialNextStepAnimation(false);        
        // }
      },
      padding: EdgeInsets.zero,
      color: palette.tileBgColor,
      iconSize: 36*sizeFactor,
      icon: const Icon(
        Icons.navigate_next_sharp,
      ),
    );
  } else {
    return const SizedBox();
  }
}