import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/game_summary_dialog.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class GameSummaryWidget extends StatefulWidget {
  final Map<String,dynamic> gameData;
  const GameSummaryWidget({
    super.key,
    required this.gameData,
  });

  @override
  State<GameSummaryWidget> createState() => _GameSummaryWidgetState();
}

class _GameSummaryWidgetState extends State<GameSummaryWidget> {

  late SettingsController settings;
  late ColorPalette palette;
  late double scalor = 1.0;
  String formattedDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settings = Provider.of<SettingsController>(context, listen: false);
    palette = Provider.of<ColorPalette>(context, listen: false);
    scalor = Helpers().getScalor(settings);

    DateTime dateTime = DateTime.parse(widget.gameData["createdAt"]);
    formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    Helpers().getTitleString(widget.gameData["gameParameters"]);






  }
  @override
  Widget build(BuildContext context) {
        return SizedBox(
          width: double.infinity,
          // height: 80*scalor,

          child: Padding(
            padding: EdgeInsets.all(8.0*scalor),
            child:Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: palette.widgetShadow1,
                    offset: Offset(0.0,10.0*scalor), 
                    blurStyle: BlurStyle.normal, 
                    blurRadius: 20.0*scalor, 
                    spreadRadius: 2.0*scalor,
                  )
                ]
              ),              
              child: ClipRRect(
                
                borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0*scalor)),
                    color: palette.widget2
                  ),
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (_) => GameSummaryDialog(gameData:widget.gameData)
                      );                      
                    },
                    // clipBehavior: Clip.antiAlias,
                    // backgroundColor: palette.widget2,
                    // collapsedBackgroundColor: palette.widget2,
                    title: Text(
                      Helpers().getTitleString(widget.gameData["gameParameters"]),
                      style: TextStyle(
                        color: palette.widgetText2,
                        fontSize: 22 * scalor,
                                
                      ),
                    ),
                                
                    trailing: Text(
                      Helpers().getScoreValue(widget.gameData),
                      style: palette.counterFont(
                        textStyle: TextStyle(fontSize: 24 * scalor, color: palette.widgetText2),
                      )
                    ),
                    // showTrailingIcon: true,
                    subtitle: Text(formattedDate,style: TextStyle(fontSize: 14*scalor, color: palette.widgetText2),),
                                
                                
                  
                  
                  ),
                ),
              ),
            )
          ),
        );
  }
}