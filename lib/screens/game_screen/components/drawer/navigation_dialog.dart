import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class NavigationDialog extends StatefulWidget {

  final String title;
  final String body;
  final VoidCallback action;
  const NavigationDialog({
    super.key,
    required this.title,
    required this.body,
    required this.action
  });

  @override
  State<NavigationDialog> createState() => _NavigationDialogState();
}

class _NavigationDialogState extends State<NavigationDialog> {

  late ColorPalette palette;
  late SettingsController settings;
  late double scalor = 1.0;
  @override
  void initState() {
    super.initState();
    palette = Provider.of<ColorPalette>(context, listen: false);
    settings = Provider.of<SettingsController>(context, listen: false);
    scalor = Helpers().getScalor(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))),          
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.6*scalor,
                colors: [palette.dialogBg1,palette.dialogBg2]
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.0*scalor,4.0*scalor,12.0*scalor,4.0*scalor),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0*scalor),
                    child: Text(
                      widget.title,
                      style: palette.mainAppFont(
                        textStyle: TextStyle(
                          color: palette.text1,
                          fontSize: 32*scalor
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0 * scalor),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.body,
                            style: palette.mainAppFont(
                              textStyle: TextStyle(
                                color: palette.text1,
                                fontSize: 18*scalor
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: palette.navigationButtonBg3,
                            foregroundColor: palette.navigationButtonText3,
                            surfaceTintColor: Colors.greenAccent,
                            
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
                            ),
                            textStyle: palette.mainAppFont(
                              textStyle: TextStyle(
                                fontSize: 16 * scalor
                              )
                            )
                          ),
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextButton(
                          // style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                          style: TextButton.styleFrom(
                            backgroundColor: palette.navigationButtonBg1,
                            foregroundColor: palette.navigationButtonText1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0*scalor))
                            ),
                            textStyle: palette.mainAppFont(
                              textStyle: TextStyle(
                                fontSize: 16 * scalor
                              )
                            )                            
                          ),              
                          child: const Text('Yes'),
                          onPressed: widget.action
                        ),
                      ),
                    ],                  
                  ),
                                    
                ],
              ),
            )
          ),
        );
      }
    );  
  }
}