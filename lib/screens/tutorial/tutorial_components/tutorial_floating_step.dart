import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/animation_state.dart';
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

  // late Animation<Offset> _slideEnterAnimation;
  // late AnimationController _slideEnterController;

  late Animation<double> _slideEnterAnimation2;
  late AnimationController _slideEnterController2;  

  late Animation<double> _slideEnterAnimation3;
  late AnimationController _slideEnterController3;    

  // late Animation<Offset> _slideExitAnimation;
  // late AnimationController _slideExitController;

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
      _runSlideAnimations();
    }

    if (_animationState.shouldRunTutorialPreviousStepAnimation) {
      _runReverseAnimations();
    }
  }

  void _runSlideAnimations() {
    // _slideEnterController.reset();
    _slideEnterController2.reset();  
    _slideEnterController3.reset();    
    // _slideExitController.reset();

    // _slideEnterController.forward();
    _slideEnterController2.forward();
    _slideEnterController3.forward();    
    // _slideExitController.forward();
  }

  void _runReverseAnimations() {
    // _slideEnterController.reverse();
    // _slideExitController.reverse();
    _slideEnterController2.reverse();
    _slideEnterController3.reverse();
     
  }


  void initializeAnimations(width) {
    // _slideEnterController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 300),
    // );

    // _slideEnterAnimation = Tween<Offset>(
    //   begin: const Offset(-2.0, 4.0),
    //   end: Offset(0.0, 4.0),
    // ).animate(_slideEnterController);

    // _slideEnterController.forward();

    // _slideExitController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 300));

    // _slideExitAnimation = Tween<Offset>(
    //   begin: Offset(0.0, 4.0),
    //   end: const Offset(-2.0, 4.0),
    // ).animate(_slideExitController);

    // _slideExitController.forward();


    _slideEnterController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideEnterAnimation2 = Tween<double>(
      begin: width*-1,
      end: 0,
    ).animate(_slideEnterController2);
    _slideEnterController2.forward();

    _slideEnterController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideEnterAnimation3 = Tween<double>(
      begin: 0,
      end: width*1,
    ).animate(_slideEnterController3);    

    // _slideEnterController2.forward();    
  }  


  void goToNextStep( TutorialState tutorialState, AnimationState animationState) {
    // late Map<String, dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
    tutorialState.setSequenceStep(tutorialState.sequenceStep + 1);
    animationState.setShouldRunTutorialNextStepAnimation(true);
    animationState.setShouldRunTutorialNextStepAnimation(false);


  }  

    
  @override
  Widget build(BuildContext context) {

    // Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(widget.tutorialState);
    // Map<String,dynamic> previousStep = TutorialHelpers().getPreviousStep2(widget.tutorialState);
    // Map<String,dynamic> previouStep = TutorialHelpers().getCurrentStep2(widget.tutorialState);


    return Consumer<TutorialState>(
      builder: (context, tutorialState, child) {

      Map<String,dynamic> currentStep = TutorialHelpers().getCurrentStep2(tutorialState);
      Map<String,dynamic> previousStep = TutorialHelpers().getPreviousStep2(tutorialState);


      print("=================================================================");
      print("right now, the step is ${currentStep['step']} ---------------------");
      print("display this guy at ${MediaQuery.of(context).size.height*(currentStep['height'] as double)} from the top");
      print("on the ${currentStep['left'] ? 'left' : 'right'} side");
      print("----------------------------------------");
      print("And it should say '${currentStep['text']}");
      print("=================================================================");    
      return Stack(
        children: [

          // ================ ACTUAL BUTTON =======================
          // ================== RIGHT SIDE ==========================
          
          AnimatedBuilder(
            animation: _slideEnterAnimation2,
            builder: (context, child) {
              return 
              Positioned(
                top: MediaQuery.of(context).size.height*(currentStep['height'] as double),
                right: _slideEnterAnimation2.value,
                child: currentStep['left'] ? SizedBox() : Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15.0,
                        sigmaY: 15.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            )
                        ),
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  child: Text(
                                    currentStep['text']
                                    // "The goal of this game is to score as many poits as possible"
                                  )
                                ),
                              ),
                              !currentStep['complete'] ? SizedBox() :
                              IconButton(
                                onPressed : () {
                                  if (currentStep['step'] == 21) {
                                    tutorialState.setSequenceStep(tutorialState.sequenceStep+15);
                                  } else {
                                    goToNextStep(tutorialState, _animationState);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                color: palette.tileBgColor,
                                iconSize: 36,
                                icon: Icon(
                                  Icons.navigate_next_sharp,
                                ),
                              )
                            ],
                          ),  
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      
          // ================ FAKE BUTTON =======================
          // ================== RIGHT SIDE ==========================      
           
          AnimatedBuilder(
            animation: _slideEnterAnimation3,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height*(previousStep['height'] as double),
                right: _slideEnterAnimation3.value*-1,
                child: currentStep['left'] ? SizedBox() : Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15.0,
                        sigmaY: 15.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            )
                        ),
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  child: Text(
                                    previousStep['text']
                                  )
                                ),
                              ),
                              !currentStep['complete'] ? SizedBox() :
                              IconButton(
                                onPressed : () {
                                  if (currentStep['step'] == 21) {
                                    tutorialState.setSequenceStep(tutorialState.sequenceStep+15);
                                  } else {
                                    goToNextStep(tutorialState, _animationState);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                color: palette.tileBgColor,
                                iconSize: 36,
                                icon: Icon(
                                  Icons.navigate_next_sharp,
                                ),
                              )
                            ],
                          ),  
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ================ ACTUAL BUTTON =======================
          // ================== LEFT SIDE ==========================



          AnimatedBuilder(
            animation: _slideEnterAnimation2,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height*(currentStep['height'] as double),
                left: _slideEnterAnimation2.value,
                child:  !currentStep['left'] ? SizedBox() : Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15.0,
                        sigmaY: 15.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            )
                        ),
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  child: Text(
                                    currentStep['text']
                                    // "The goal of this game is to score as many poits as possible"
                                  )
                                ),
                              ),
                              !currentStep['complete'] ? SizedBox() :
                              IconButton(
                                onPressed : () {
                                  if (currentStep['step'] == 21) {
                                    tutorialState.setSequenceStep(tutorialState.sequenceStep+15);
                                  } else {
                                    goToNextStep(tutorialState, _animationState);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                color: palette.tileBgColor,
                                iconSize: 36,
                                icon: Icon(
                                  Icons.navigate_next_sharp,
                                ),
                              )
                            ],
                          ),  
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      
          // ================ FAKE BUTTON =======================
          // ================== LEFT SIDE ==========================      
      

          AnimatedBuilder(
            animation: _slideEnterAnimation3,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height*(previousStep['height'] as double),
                left: _slideEnterAnimation3.value*-1,
                child:  !currentStep['left'] ? SizedBox() : Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15.0,
                        sigmaY: 15.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            )
                        ),
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  child: Text(
                                    previousStep['text']
                                  )
                                ),
                              ),
                              !currentStep['complete'] ? SizedBox() :
                              IconButton(
                                onPressed : () {
                                  if (currentStep['step'] == 21) {
                                    tutorialState.setSequenceStep(tutorialState.sequenceStep+15);
                                  } else {
                                    goToNextStep(tutorialState, _animationState);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                color: palette.tileBgColor,
                                iconSize: 36,
                                icon: Icon(
                                  Icons.navigate_next_sharp,
                                ),
                              )
                            ],
                          ),  
                        ),
                      ),
                    ),
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