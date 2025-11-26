import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:scribby_flutter_v2/components/bonus_icons.dart';
import 'package:scribby_flutter_v2/functions/gestures.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';

class WidgetUtils {


  TextPainter displayTileText(Canvas canvas, String body, Color color, Offset location, double fontSize, ColorPalette palette) {


    TextStyle textStyle = palette.tileFont(
      textStyle: TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );
    // TextStyle textStyle = googleFont( //akayaKanadaka
    //   color: color, //const Color.fromARGB(190, 123, 191, 255),
    //   fontSize: fontSize,
    // );
    TextSpan textSpan = TextSpan(
      text: body,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    final position = Offset(location.dx - (textPainter.width/2), location.dy - (textPainter.height/2));
    textPainter.paint(canvas, position);
    return textPainter;   
  }

  List<TableRow> getSummaryTableRows(BuildContext context, GamePlayState gamePlayState, double scalor, ColorPalette palette) {

    List<TableRow> rows = [];
    for (int i=0; i<gamePlayState.scoreSummary.length; i++) {
      Map<String,dynamic> turnObject = gamePlayState.scoreSummary[i];


      if (turnObject["score"] > 0 ) {
          int turn = turnObject["turn"];
          int score = turnObject["score"];


        List<Widget> stringItems = [];

        // get the list of words
        for (int j=0; j<turnObject["validStrings"].length; j++) {
          Map<String,dynamic> stringObject = turnObject["validStrings"][j];

          String word = stringObject["word"].toString();
          Widget wordWidget =  GestureDetector(
            onTap: ()=>Gestures().openViewDefinitionDialog(context, word),
            child: Text(word,style: TextStyle(color: palette.text1, fontSize: 20 * scalor),)
          );
          stringItems.add(wordWidget);
        }

        // get the row of multipliers
        List<Widget> multipliers = [];
        if (turnObject["multipliers"]["streak"]>1) {
          // Widget item = Icon(Icons.bolt,color: Colors.white,size: 14,);
          Widget item = SizedBox(
            width: 25*scalor,
            height: 25*scalor,
            child: CustomPaint(
              painter: BonusIconPaitner(bonusType: "streak",scalor: scalor,color: palette.text1),
            ),
          );
          multipliers.add(item);

        }
        if (turnObject["multipliers"]["cross"]==2) {
          // Widget item = Icon(Icons.close,color: Colors.white,size: 14);
          Widget item = SizedBox(
            width: 25*scalor,
            height: 25*scalor,          
            child: CustomPaint(
              painter: BonusIconPaitner(bonusType: "cross",scalor: scalor,color: palette.text1),
            ),
          );        
          multipliers.add(item);
        }
        if (turnObject["multipliers"]["words"]> 1) {
          // Widget item = Icon(Icons.wordpress,color: Colors.white,size: 14);
          Widget item = SizedBox(
            width: 25*scalor,
            height: 25*scalor,          
            child: CustomPaint(
              painter: BonusIconPaitner(bonusType: "words",scalor: scalor,color: palette.text1),
            ),
          );        
          multipliers.add(item);
        }


        TableRow tableRow = TableRow(
          children: [

            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Align(
                alignment: Alignment.center,
                child: Text(turn.toString(),style: TextStyle(color: palette.text1, fontSize: 20 * scalor),),
              )
            ),

            TableCell(
              child: Center(
                child: Column(
                  children: stringItems,
                ),
              )
            ),

            TableCell(
              child: Center(
                child: Wrap(
                  children: multipliers,
                ),
              )
            ),           

            TableCell(
              child: Center(
                child: Text(score.toString(),style: TextStyle(color: palette.text1, fontSize: 20 * scalor),),
              )
            ),                        
          ]
        );      
        rows.add(tableRow);
      }
    }
    return rows;
  }


  Widget headingItem(String body, double scalor, ColorPalette palette) {
    return TableCell(
      child: Container(
        child: Center(
          child: Text(
            body,
            style: TextStyle(
              color: palette.text1,
              fontWeight: FontWeight.w600,
              fontSize: 20*scalor ),),),));
  }

  Widget instructionsText(
    Color color, 
    String body, 
    String language, 
    bool dynamicValue, 
    double fontSize, 
    // Map<dynamic,dynamic> translateDemoSequence,
    // SettingsState settingsState
    ) {
    String res = "";
    // if (dynamicValue) {
    //   res = Helpers().translateDemoSequence(language, body, translateDemoSequence,settingsState);
    // } else {
    //   res = Helpers().translateText(language, body,settingsState);
    // }
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: DefaultTextStyle(
        child: Text(
          body, //res,
        ),
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }

  Widget instructionsHeading(Color color, String body, String language, double fontSize) {
    String res = body; //"";
    // res = Helpers().translateText(language, body,settingsState);
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DefaultTextStyle(
          child: Text(
            res,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color
          ),
        ),
      ),
    );
  }

  List<Widget> getDefinitions(List<dynamic> definitions, double scalor, ColorPalette palette, String language) {

    late List<Widget> cols = [];

    if (language =='en') {
      for (int i=0; i<definitions.length; i++) {


        if (definitions[i] is Map<String, dynamic>) {

          String partOfSpeech = "";
          String string = "";
          final Map<String, dynamic> something = definitions[i] as Map<String, dynamic>;
          partOfSpeech = something["partOfSpeech"];
          string = something["string"];
          late List<TableRow> rows = [];
          late TableRow partOfSpeechRow = TableRow(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${(i+1).toString()}. ",
                  style: TextStyle(
                    color: palette.text1,
                    fontWeight: FontWeight.w800,
                    fontSize: 18 * scalor 
                  ),
                ),            
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // partOfSpeech,
                  partOfSpeech,
                  style: TextStyle(
                    color: palette.text1,
                    fontWeight: FontWeight.w800,
                    fontSize: 18 * scalor, 
                  ),
                ),            
              ),
            ]
          );
          rows.add(partOfSpeechRow);
          late TableRow definitionRow = TableRow(
            children: [
              SizedBox(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // string,
                  string,
                  style: TextStyle(
                    color: palette.text1,
                    fontSize: 18 * scalor           
                  ),
                ),            
              ),          
            ]
          );
          rows.add(definitionRow);
          late Table tableRes = Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(9),
            },
            defaultVerticalAlignment:TableCellVerticalAlignment.middle,
            children: rows,
          );  
          cols.add(tableRes);
          cols.add(Divider(color: palette.text1,thickness: 1.0 * scalor,));

        }

      }
    } else {
      for (int i=0; i<definitions.length; i++) {
        final String definition = definitions[i];
        late List<TableRow> rows = [];
        late TableRow definitionRow = TableRow(
          children: [
            Container(
              // color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "${(i+1).toString()}. ",
                      style: TextStyle(
                        color: palette.text1,
                        fontWeight: FontWeight.w800,
                        fontSize: 18 * scalor 
                      ),
                    ),            
                  ),
                  
                ]
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                definition,
                style: TextStyle(
                  color: palette.text1,
                  fontSize: 16 * scalor, 
                ),
              ),            
            ),
          ]
        );
        rows.add(definitionRow);
        late Table tableRes = Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(9),
          },
          defaultVerticalAlignment:TableCellVerticalAlignment.middle,
          // border: TableBorder(bottom: BorderSide(width: 0.5, color: palette.text1, style: BorderStyle.solid)),     
          children: rows,
        );  
        cols.add(tableRes);
        final Divider divider = Divider(thickness: 1, color: palette.text1.withOpacity(0.2),);
        cols.add(divider);            
      }
    }

    return cols;
  }


  Widget definitionModal(double scalor, ColorPalette palette, String word, Map<String,dynamic> definition,) {


    List<Widget> definitions = [];
    String language = "en";
    if (definition['result'] != 'success') {
      Text(definition['data']);
    } else {


      if (language == 'en') {
        print("""

      -----------------------
      ${definition["data"]};
      ------------------------
      """);
        definitions = WidgetUtils().getDefinitions(definition['data'], scalor, palette, language);
      } else {
        definitions = WidgetUtils().getDefinitions(definition['data']['data'], scalor, palette, language);
      }      
    }



    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))),        
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.6*scalor,
            colors: [palette.dialogBg1,palette.dialogBg2,]
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
        ),
        padding: EdgeInsets.all(8.0*scalor),
        width: double.maxFinite,
    
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: scalor*500
          ),
          child: Padding(
            padding: EdgeInsets.all(4.0 *scalor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  word,
                  style: palette.mainAppFont(
                    textStyle: TextStyle(
                      color: palette.text1,
                      fontSize: 22*scalor
                    ),
                  ) 
                ),
            
                Divider(
                  color: palette.text1,
                  thickness:1.0*scalor
                ),
                definition['result'] != 'success' 
                ? Text(definition['data'],style: TextStyle(color: palette.text1),)
                : Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: definitions
                    ),
                  ),
                )
              ],
            ),
          ),
        ), 
      ),
    );  
  }



  


}