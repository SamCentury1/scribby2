import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/components/instructions_column.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializeBannerAd();
  }




  @override
  Widget build(BuildContext context) {
    // final banner = context.watch<AdState>().bannerAd;
    // _banner = _adState.bannerAd;
    return Consumer<SettingsState>(
      builder: (context,settingsState,child) {

        ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
        SettingsController settings = Provider.of<SettingsController>(context, listen: false);

        late double scalor = Helpers().getScalor(settings);
        final double menuPositionTop = MediaQuery.of(context).padding.top-5;

        return PopScope(
          canPop: true,
          child: SizedBox(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,            
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 1,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                      child: CustomPaint(
                        painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
                      ),
                    ),
                  ),             
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    onDrawerChanged: (var details) {},
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(0, 49, 49, 49),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: palette.appBarText,),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      title: Text(
                        "How to Play",
                        style: palette.mainAppFont(
                          textStyle: TextStyle(
                            color: palette.text1,
                            fontSize: 28 * scalor
                          )
                        ),
                      ),
                    ),

                    body: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InstructionsColumn(
                                scalor: scalor, 
                                screenWidth: MediaQuery.of(context).size.width, 
                                settingsState: settingsState,
                                palette: palette,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
