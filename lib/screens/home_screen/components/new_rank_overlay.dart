import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/animation_utils.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class NewRankOverlay extends StatefulWidget {
  const NewRankOverlay({super.key});

  @override
  State<NewRankOverlay> createState() => _NewRankOverlayState();
}

class _NewRankOverlayState extends State<NewRankOverlay> {

  // Timer? _timer;

  late bool shouldShowOverlay = false;

  late SettingsController settings;
  Size fireworksSize = Size(0,0);

  List<Map<String,dynamic>> fireworksData = [];
  late String rankString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context,listen: false);

    Map<dynamic,dynamic> achievements = settings.achievements.value as Map<dynamic,dynamic>;
    // Map<dynamic,dynamic> achievements = {"rank":"4_1", }; FOR TESTING ONLY
    if (achievements.isNotEmpty) {
      if (achievements["rank"] != null) {
        print("show the overlay!");
        setState(() {
          shouldShowOverlay = true;

          Map<String,dynamic> deviceSizeInfo = settings.deviceSizeInfo.value as Map<String,dynamic>;
          final double dw = deviceSizeInfo["width"];
          final double dh = deviceSizeInfo["height"];    
          fireworksData = AnimationUtils().generateFireworksData(Size(dw,dh));


          print("in the new rank overlay - $achievements");

          Map<String,dynamic> rankObject = settings.rankData.value.firstWhere((e)=>e["key"]==achievements["rank"],orElse: () => <String,dynamic>{});
          if (rankObject.isNotEmpty) {
            rankString = "Level ${rankObject["level"]} ${rankObject["rankName"]}";
          }
                    
        });
        startTimer();
      } 
    } 





    // startTimer();

  }

  late double animationProgress = 0.0;

  void startTimer() {
    late int count = 0;
    late int target = 200;
    Timer.periodic(const Duration(milliseconds: 20), (Timer t) {
      if (count >= target) {
        t.cancel();
        setState(() {
          shouldShowOverlay = false;
          print("no more show overlay!");
          count = 0;
        });

      } else {
        setState(() {
          count = count+1;
          animationProgress = count/target;
        });
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {



    // SettingsController settings = Provider.of<SettingsController>(context,listen: false);

    return Consumer<SettingsController>(
      builder:(context, settings, child) {




        final double scalor = Helpers().getScalor(settings);
        Map<String,dynamic> deviceSizeInfo = settings.deviceSizeInfo.value as Map<String,dynamic>;
        // final double dw = deviceSizeInfo["width"];
        // final double dh = deviceSizeInfo["height"];


        List<Map<String,dynamic>> overlayOpacityAnimationDetails = [
          {"source": 0.0, "target": 1.0, "duration": 0.10},
          {"source": 1.0, "target": 1.0, "duration": 0.80},
          {"source": 1.0, "target": 0.0, "duration": 0.10},
        ];
        double overlayOpacity = AnimationUtils().getAnimationTransition(animationProgress,overlayOpacityAnimationDetails);  

        // -------------------------------------------------------------------

        List<Map<String,dynamic>> labelOpacityAnimationDetails = [
          {"source": 0.0, "target": 1.0, "duration": 0.05},
          {"source": 1.0, "target": 1.0, "duration": 0.20},
          {"source": 1.0, "target": 0.0, "duration": 0.05},
          {"source": 0.0, "target": 0.0, "duration": 0.70},
        ];
        double labelOpacity = AnimationUtils().getAnimationTransition(animationProgress,labelOpacityAnimationDetails);   

        List<Map<String,dynamic>> labelPositionYAnimationDetails = [
          {"source": 0.0, "target": -30.0, "duration": 0.05},
          {"source": -30.0, "target": -40.0, "duration": 0.20},
          {"source": -40.0, "target": -60.0, "duration": 0.05},
          {"source": -60.0, "target": -60.0, "duration": 0.70},
        ];
        double labelPositionY = AnimationUtils().getAnimationTransition(animationProgress,labelPositionYAnimationDetails);           

        // ----------------------------------------------------------

        List<Map<String,dynamic>> rankOpacityAnimationDetails = [
          {"source": 0.0, "target": 0.0, "duration": 0.20},
          {"source": 0.0, "target": 1.0, "duration": 0.05},
          {"source": 1.0, "target": 1.0, "duration": 0.70},
          {"source": 1.0, "target": 0.0, "duration": 0.05},
        ];
        double rankOpacity = AnimationUtils().getAnimationTransition(animationProgress,rankOpacityAnimationDetails);

        List<Map<String,dynamic>> rankPositionYAnimationDetails = [
          {"source": 0.0, "target": 0.0, "duration": 0.20},
          {"source": 0.0, "target": -30.0, "duration": 0.05},
          {"source": -30.0, "target": -30.0, "duration": 0.70},
          {"source": -30.0, "target": -60.0, "duration": 0.05},
        ];
        double rankPositionY = AnimationUtils().getAnimationTransition(animationProgress,rankPositionYAnimationDetails);


        if (shouldShowOverlay) {
          return Positioned(
            top: -0,
            child: ClipRRect(
              child: GestureDetector(

                child: Container(
                  width: MediaQuery.of(context).size.width, 
                  height: MediaQuery.of(context).size.height, 
                  child: Stack(
                    children: [

                      Container(
                        width: MediaQuery.of(context).size.width, //deviceSizeInfo["width"],
                        height: MediaQuery.of(context).size.height, //deviceSizeInfo["height"],
                        
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.651 * overlayOpacity)
                        ),
                      ),

                      Positioned(
                        top: (deviceSizeInfo["height"]/2) - 100 + labelPositionY,
                        child: SizedBox(
                          width: deviceSizeInfo["width"],
                          child: Center(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1 * labelOpacity ),
                                fontSize: 32*scalor
                              ),
                              child: Text(
                                "New Level Achieved!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.luckiestGuy(
                                  textStyle: TextStyle(
                                    // fontSize: 44.0,
                                  )
                                ),
                                // shouldShowOverlay.toString()
                              )
                            ),
                          ),
                        ),
                      ),


                      Positioned(
                        top: (deviceSizeInfo["height"]/2) - 50 + rankPositionY,
                        child: SizedBox(
                          width: deviceSizeInfo["width"],
                          child: Center(
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1 * rankOpacity),
                                fontSize: 44*scalor,
                                shadows: [
                                  BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 1 * rankOpacity * AnimationUtils().getOscillatingEffect(animationProgress,0,30)), 
                                    offset: Offset.zero, 
                                    blurRadius: 40.0 * AnimationUtils().getOscillatingEffect(animationProgress,0,30), 
                                    spreadRadius: 50.0 * AnimationUtils().getOscillatingEffect(animationProgress,0,30) 
                                  ),

                                  BoxShadow(
                                    color: Color.fromRGBO(251, 255, 17, 1  * rankOpacity * AnimationUtils().getOscillatingEffect(animationProgress,10,30)), 
                                    offset: Offset.zero, 
                                    blurRadius: 40.0 * AnimationUtils().getOscillatingEffect(animationProgress,10,30), 
                                    spreadRadius: 50.0 * AnimationUtils().getOscillatingEffect(animationProgress,10,30)
                                  ),

                                  BoxShadow(
                                    color: Color.fromRGBO(255, 8, 8, 1 * rankOpacity * AnimationUtils().getOscillatingEffect(animationProgress,20,30)), 
                                    offset: Offset.zero, 
                                    blurRadius: 40.0 * AnimationUtils().getOscillatingEffect(animationProgress,20,30), 
                                    spreadRadius: 50.0  * AnimationUtils().getOscillatingEffect(animationProgress,20,30)
                                  ),
                                ]
                              ),
                              child: Text(
                                rankString,
                                style: GoogleFonts.luckiestGuy(
                                  textStyle: TextStyle(
                                    fontSize: 66 * scalor
                                  )
                                ),
                                textAlign: TextAlign.center,
                                // shouldShowOverlay.toString()
                              )
                            ),
                          ),
                        ),                        
                      ),

                      Builder(
                        builder: (context) {
                          
                          List<Widget> explosions = [];
                          for (int i=0; i<fireworksData.length; i++) {
                            Map<String,dynamic> fireworkObject = fireworksData[i];
                            List<Map<String,dynamic>> explosionData = fireworkObject["explosionData"];
                            List<Map<String,dynamic>> progressDetails = fireworkObject["progressDetails"];
                            double fireworksProgress = AnimationUtils().getAnimationTransition(animationProgress,progressDetails); 


                            Widget res = Positioned(
                              // top: fireworksCenter1.dy,
                              // left: fireworksCenter1.dx,
                              child: Container(
                                // color: Colors.yellow,
                                width: fireworksSize.width,
                                height: fireworksSize.height,
                                child: CustomPaint(
                                  painter: FireworksPainter(index: i, progress: fireworksProgress, explosionData: explosionData),
                                ),
                              )
                            );
                            explosions.add(res);

                          }
                          return Stack(
                            children: explosions,
                          );

                          // return SizedBox(); 
                        }
                      )

                    ],
                  ),
                ),
              ),
            ),
          );          
        } else {
          return SizedBox();
        }

      }
    );
  }
}



class FireworksPainter extends CustomPainter {
  final int index;
  final double progress;
  final List<Map<String,dynamic>> explosionData;
  FireworksPainter({
    required this.index,
    required this.progress,
    required this.explosionData,
  });
   
  @override  
  void paint(Canvas canvas, Size size) {

    List<Color> colors = [
      Colors.yellow,
      Colors.red,
      Colors.orange,
    ];

    for (int j=0; j<explosionData.length;j++) {
      Map<String,dynamic> particleData = explosionData[j];
      Map<String,dynamic> delayData = particleData["delay"];

      List<Map<String,dynamic>> opacityAnimationDetails = [
        {"source": 0.0, "target": 0.0, "duration": delayData["start"]},
        {"source": 0.0, "target": 1.0, "duration": delayData["rise"]},
        {"source": 1.0, "target": 1.0, "duration": delayData["middle"]},
        {"source": 1.0, "target": 0.0, "duration": delayData["decline"]},
        {"source": 0.0, "target": 0.0, "duration": delayData["end"]},
      ];      
      double opacityProgress = AnimationUtils().getAnimationTransition(progress,opacityAnimationDetails);            


      // Color color = Helpers().getParticleColor(particleData["color"],tileType,tileBody,decorationData);
      Color baseColor = colors[index%colors.length];
      Color color = AnimationUtils().getFireworksColor(particleData["color"],baseColor);
      // print("r: ${color.r} | g: ${color.g} | b: ${color.b}");
      // Color updatedColor = Color.fromRGBO(color.r., color.g, color.b, opacityProgress);
      int red = (color.r * 255).round();
      int green = (color.g * 255).round();
      int blue = (color.b * 255).round();

      Color particleColor = Color.fromRGBO(red, green, blue, opacityProgress);
      
      Paint explosionPaint = Paint();
      explosionPaint.style = PaintingStyle.fill;
      explosionPaint.color = particleColor;

      final Offset particleCenter = particleData["center"];

      final double particleDistance = particleData["distance"] * progress;
      final Offset particlePosition = AnimationUtils().getParticlePoint(particleData["angle"], particleCenter, particleDistance);

      // Path particleShape = Helpers().getParticleShapePath(particlePosition,particleData["shape"]);
      
      canvas.drawCircle(particlePosition,2.0*particleData["size"],explosionPaint);
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(FireworksPainter oldDelegate) => false;  
}

