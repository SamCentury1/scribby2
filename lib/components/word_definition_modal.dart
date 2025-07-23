import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/widget_utils.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';




// class WordDefinitionModal extends StatefulWidget {
//   final String word;
//   // final Map<String,dynamic> definition;
//   const WordDefinitionModal({
//     super.key,
//     required this.word,
//     // required this.definition,
//   });

//   @override
//   State<WordDefinitionModal> createState() => _WordDefinitionModalState();
// }

// class _WordDefinitionModalState extends State<WordDefinitionModal> {

//   List<Widget> definitions = [];

  
//   late ColorPalette palette;
//   late SettingsController settings;
//   late double scalor = 1.0;
//   late String language = "english";


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     palette = Provider.of<ColorPalette>(context, listen: false);
//     settings = Provider.of<SettingsController>(context, listen: false);
//     Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
//     language = userData["language"]??"english";
//     scalor = Helpers().getScalor(settings);



//   }

//   @override
//   Widget build(BuildContext context) {

    
//     return FutureBuilder<Map<String,dynamic>>(
//         future: Helpers().fetchDefinition("word","english"),
//         builder: (context, snapshot) {
//           print("snapshot: ${snapshot.data??{}}");
//           late Map<String,dynamic> res = {};
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             res = {"result" : "loading", "data": "loading..."};
//             // return definitionModal(scalor, palette, widget.word, res)
//             // return WordDefinitionModal(word: word, definition: res);
//           } else if (snapshot.hasError) {
//             res = {"result" : "fail", "data": "Error fetching definition"};
//             // return WordDefinitionModal(word: word, definition: res);
//           } else {
//             if (snapshot.data != null) {
//               print("snapshot: ${snapshot.data}");
//               res = snapshot.data!;
//               // return WordDefinitionModal(word: word, definition: snapshot.data!);
//             } else {
//               res = {"result" : "fail", "data":  "No definition available at this time"};
//               // return WordDefinitionModal(word: word, definition: res);
//             }
//           }

//           print("res: $res");


//           if (res['result'] != 'success') {

//             Text(res['data']);
//           } else {

//             if (language == 'english') {              
//               setState(() {
//                 definitions = WidgetUtils().getDefinitions(res['data']['data'], scalor, palette, language);
//               });

//             } else {
//               setState(() {
//                 definitions = WidgetUtils().getDefinitions(res['data'], scalor, palette, language);
//               });
//             }      
//           }          

//           return definitionModal(scalor, palette, widget.word, res,definitions);             
//         },        
//     );

//   }
// }


// Widget definitionModal(double scalor, ColorPalette palette, String word, Map<String,dynamic> definition,) {


//   List<Widget> definitions = [];
//   String language = "en";
//   if (definition['result'] != 'success') {
//     Text(definition['data']);
//   } else {


//     if (language == 'en') {
//       print("""

//     -----------------------
//     ${definition["data"]};
//     ------------------------
//     """);
//       definitions = WidgetUtils().getDefinitions(definition['data'], scalor, palette, language);
//     } else {
//       definitions = WidgetUtils().getDefinitions(definition['data']['data'], scalor, palette, language);
//     }      
//   }



//   return Dialog(
//     backgroundColor: Colors.transparent,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))),        
//     child: Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           radius: 0.6*scalor,
//           colors: [palette.dialogBg1,palette.dialogBg2,]
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
//       ),
//       padding: EdgeInsets.all(8.0*scalor),
//       width: double.maxFinite,
  
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxHeight: scalor*500
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(4.0 *scalor),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 word,
//                 style: palette.mainAppFont(
//                   textStyle: TextStyle(
//                     color: palette.text1,
//                     fontSize: 22*scalor
//                   ),
//                 ) 
//               ),
          
//               Divider(
//                 color: palette.text1,
//                 thickness:1.0*scalor
//               ),
//               definition['result'] != 'success' 
//               ? Text(definition['data'],style: TextStyle(color: palette.text1),)
//               : Flexible(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: definitions
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ), 
//     ),
//   );  
// }

