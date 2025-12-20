import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/components/badge_painters.dart';
import 'package:scribby_flutter_v2/screens/statistics_screen.dart/views/badges_view.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameOverBadgeSection extends StatefulWidget {
  final List<dynamic> badgeData;
  const GameOverBadgeSection({
    required this.badgeData,
    super.key
  });

  @override
  State<GameOverBadgeSection> createState() => _GameOverBadgeSectionState();
}

class _GameOverBadgeSectionState extends State<GameOverBadgeSection> {

  late SettingsController settings;
  late GamePlayState gamePlayState;
  late double scalor = 1.0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    settings = Provider.of<SettingsController>(context,listen: false);
    scalor = Helpers().getScalor(settings);
  }

  @override
  Widget build(BuildContext context) {

    if (widget.badgeData.isEmpty) return const SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        // The height your Expanded gives this section
        final double availableHeight = 80.0; //constraints.maxHeight;

        // Pick badge size based on available height
        final double badgeSize = availableHeight ; // or whatever ratio you want
        return Padding(
          padding: EdgeInsets.only(top: 18*scalor),
          child: SizedBox(
            height: availableHeight,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => SizedBox(width: 12.0 * scalor),
              itemCount: widget.badgeData.length,
              itemBuilder: (context, i) {
                final Map<String, dynamic> data = widget.badgeData[i];
                    
                return GestureDetector(
                  onTap: () => openBadgeDialog(context, data, scalor),
                  child: SizedBox(
                    width: badgeSize,
                    height: badgeSize,
                    child: CustomPaint(
                      painter: BadgePainter(badgeData: data),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );    
    // return Builder(
    //   builder: (context) {
    //     if (widget.badgeData.isNotEmpty) {
    //       print("DISPLAY THE BADGES!");
    //       return Container(
    //         child: Center(
    //           child: Column(
    //             children: [
    //               SizedBox(height: 20*scalor,),
    //               Builder(
    //                 builder: (context) {
    //                   List<Widget> res = [];
    //                   // final double itemWidth = min(50*scalor,gamePlayState.elementSizes["screenSize"].width/widget.badgeData.length);
    //                   final double itemWidth = (80.0 * scalor);
    //                   for (int i=0; i<widget.badgeData.length; i++){
    //                     Map<String ,dynamic> badgeDetails = widget.badgeData[i] as Map<String ,dynamic>;
    //                     Widget badge = GestureDetector(
    //                       onTap: () {
    //                         openBadgeDialog(context,badgeDetails,scalor);                                                                  
    //                       },
    //                       child: Container(
    //                         width: itemWidth,
    //                         height: itemWidth,
    //                         // color: Colors.yellow,
    //                         child: CustomPaint(
    //                           painter: BadgePainter(badgeData: badgeDetails),
    //                         ),
    //                       ),
    //                     );
    //                     res.add(badge);
    //                   }
    //                   return Container(
    //                     margin: EdgeInsets.symmetric(vertical: 20.0),
    //                     height: 80.0,                        
    //                     child: ListView(
    //                       scrollDirection: Axis.horizontal,
    //                       children: res,
    //                     ),
    //                   );
    //                   // return Row(
    //                   //   mainAxisAlignment: MainAxisAlignment.center,
    //                   //   children: res,
    //                   // );
    //                 }
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     } else {
    //       return SizedBox();
    //     }
    //   }
    // );
  }
}