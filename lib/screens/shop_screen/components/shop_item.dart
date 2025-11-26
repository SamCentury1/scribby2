import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class ShopItem extends StatelessWidget {
  final String fileName;
  final String label;
  final double cost;
  const ShopItem({
    super.key,
    required this.fileName,
    required this.label,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    final double scalor = Helpers().getScalor(settings);
    return Card(
      color: palette.widget2,
      child: Padding(
        padding: EdgeInsets.all(12.0 * scalor),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 50*scalor,
                height: 50*scalor,
                child: Image(
                  semanticLabel: "coins",
                  image: AssetImage(
                    'assets/images/$fileName.png'
                  )
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: palette.mainAppFont(
                  textStyle: TextStyle(
                    color: palette.widgetText2,
                    fontSize: 22 * scalor
                  )
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(4.0 * scalor),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.widget1,
                    foregroundColor: palette.widgetText1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                    ),
                    padding: EdgeInsets.all(8.0*scalor)
                  ),
                  onPressed: () => print("$label is gonna cost ya $cost"),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                        "\$ ${cost.toString()}",
                          style: palette.mainAppFont(
                            // color: Colors.white,
                            textStyle: TextStyle(
                              fontSize: 24*scalor,
                            ),
                          ),
                        ),
                      ),                                                                                
                  
                ),

              )
            ),
          ],
        ),
      ),
    );
  }
}