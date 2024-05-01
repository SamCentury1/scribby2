import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScribbyLogoAnimation2 extends StatefulWidget {
  const ScribbyLogoAnimation2({super.key});

  @override
  State<ScribbyLogoAnimation2> createState() => _ScribbyLogoAnimation2State();
}

class _ScribbyLogoAnimation2State extends State<ScribbyLogoAnimation2>  with SingleTickerProviderStateMixin{

  late final AnimationController _slideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..forward();

  late final Animation<Offset> _positionAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {

    super.initState();

    /// POSITION
    // _positionAnimation = TweenSequence<double>([
    //   TweenSequenceItem(
    //     tween: Tween<double>(begin: 200.0, end: 10.0), 
    //     weight: 1.0
    //   ),     
    // ]).animate(_slideController);
    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController, 
      curve: Curves.easeInOutQuint
      )
    );


    /// OPACITY
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0), 
        weight: 1.0
      ),              
    ]).animate(CurvedAnimation(
      parent: _slideController, 
      curve: Curves.easeInOutQuint
      )
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context,child)  {
        return AnimatedOpacity(
          opacity: _opacityAnimation.value,
          duration: const Duration(milliseconds: 1000),
          child: SlideTransition(
            position: _positionAnimation,
            child: Image(
              image: AssetImage('assets/images/scribby_label_1.png')
            )
          ),
        );
      },
    );
  }
}