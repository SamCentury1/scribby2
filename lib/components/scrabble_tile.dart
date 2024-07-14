import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class ScrabbleTile extends StatelessWidget {
  final Map<String,dynamic> letterData;
  // final int index;
  
  const ScrabbleTile({super.key,  required this.letterData});

  @override
  Widget build(BuildContext context) {
    
    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen:false);
    final double ts = gamePlayState.tileSize;
    return Container(
      width: ts,
      height: ts,

      child: Stack(
        children: [
          Positioned(
            top: (ts-(ts*0.8))/2,
            left: (ts-(ts*0.8))/2,
            child: Container(
              width: ts*0.8,
              height: ts*0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 227, 207, 170),
                    Color.fromARGB(255, 185, 164, 125),
                    Color.fromARGB(255, 165, 145, 109),
                  ],
                  tileMode: TileMode.mirror
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 139, 122, 89),
                    offset: Offset(ts*0.05, ts*0.05)
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(ts*0.1))      
              ),
              child: Center(
                child: DefaultTextStyle(
                  child: Text(
                    letterData['letter'],
                  ),
                  style: TextStyle(
                    fontSize: ts*0.40,
                    color: Colors.black
                  ),
                ),
              ),
            )
          ),
          Positioned(
            bottom: ts*0.1,
            right: ts*0.1,
            child: Container(
              width: ts*0.3,
              height: ts*0.3,
              // color: Colors.orange,
              child: Center(
                child: DefaultTextStyle(
                  child: Text(
                    letterData['points'].toString(),
                  ),
                  style: TextStyle(
                    fontSize: ts*0.20,
                    color: Colors.black
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}