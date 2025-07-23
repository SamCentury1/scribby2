import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/functions/widget_utils.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class SummaryView extends StatelessWidget {
  final VoidCallback onBack;
  const SummaryView({
    super.key,
    required this.onBack
  });

  @override
  Widget build(BuildContext context) {
  /// Builds the settings view with an independent `onBack` callback
    SettingsController settings = Provider.of<SettingsController>(context,listen: false);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double scalor = Helpers().getScalor(settings);
        List<TableRow> rows = WidgetUtils().getSummaryTableRows(context,gamePlayState,scalor);

        return SizedBox(
          height: gamePlayState.elementSizes["screenSize"].height,
          child: Column(
            key: const ValueKey('summaryView'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150* gamePlayState.scalor,
                child: Row(
                  // alignment: Alignment.centerLeft,
                  children: [
                    IconButton(
                      onPressed: onBack, 
                      icon: Icon(Icons.arrow_back, color: Colors.white ),
                      iconSize: 34 * scalor,
                    ),
                    Text("Summary Table", style: TextStyle(color: Colors.white, fontSize: 26*scalor),)
                  ] 
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0 * scalor),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(),
                            3: FlexColumnWidth(),
                          },
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          border: TableBorder(
                            horizontalInside: BorderSide(width: 1.0, color: const Color.fromARGB(139, 255, 255, 255)) 
                          ),
                          children: [
                            TableRow(
                              children: [
                                WidgetUtils().headingItem("Trun",scalor),
                                WidgetUtils().headingItem("Words",scalor),
                                WidgetUtils().headingItem("Bonus",scalor),
                                WidgetUtils().headingItem("Points",scalor),
                              ]
                            ), ... rows
                          ],
                        ),                       
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );

  }
}