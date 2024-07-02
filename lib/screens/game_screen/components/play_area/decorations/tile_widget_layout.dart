// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:scribby_flutter_v2/styles/palette.dart';

// class TileWidgetLayout extends StatelessWidget {
//   final double tileSize;
//   final String body;
//   final Decoration decoration;
//   const TileWidgetLayout({
//     super.key,
//     required this.tileSize,
//     required this.body,
//     required this.decoration,
//   });

//   @override
//   Widget build(BuildContext context) {


//     final ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
//     return Container(
//       width: tileSize,
//       height: tileSize,
//       child: Stack(
//         children: [          
//           Positioned(
//             top:(tileSize*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
//             left: (tileSize*0.05), // to center, equals to (tileSize-tileSize*0.9)/2
            
//             child: Container(
//               width: tileSize*0.9,
//               height: tileSize*0.9,
//               // decoration: body == "" ? Decorations().getEmptyTileDecoration() : Decorations().getTileDecoration(),
//               decoration: decoration,
//               child: Center(
//                 child: Text(
//                   body,
//                   style: TextStyle(
//                     fontSize: tileSize*0.9*0.5, 
//                     color: palette.fullTileTextColor, // Color.fromRGBO(64, 64, 64, 1),
//                   ),
//                 ),
//               ),
//             ),
//           ),                  
//         ],
//       ),
//     );
//   }
// }