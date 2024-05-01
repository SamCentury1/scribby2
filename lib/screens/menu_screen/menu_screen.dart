import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/scribby_logo_animation.dart';
import 'package:scribby_flutter_v2/components/scribby_logo_animation_2.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/game_screen.dart';
import 'package:scribby_flutter_v2/screens/instructions_screen/instructions_screen.dart';
import 'package:scribby_flutter_v2/screens/leaderboards_screen/leaderboards_screen.dart';
import 'package:scribby_flutter_v2/screens/settings_screen/settings_screen.dart';
import 'package:scribby_flutter_v2/screens/welcome_user/choose_language.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:scribby_flutter_v2/styles/palette.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  late bool isLoading = false;



  @override
  void initState() {
    super.initState();
    // loadAsset();

  }
  void navigateToChooseLanguage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ChooseLanguage()));
  }

  Future<Map<String,dynamic>> getDataFromStorage() async {

    late Map<String,dynamic> res = {};
    return res;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String> loadAsset() async {
  //   return await rootBundle.loadString('assets/config.json');
  // }  




  @override
  Widget build(BuildContext context) {


        late GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
        late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
        late SettingsController settings = Provider.of<SettingsController>(context, listen: false);
        late AudioController audioController = Provider.of<AudioController>(context, listen: false);

        return FutureBuilder(
          future: getDataFromStorage(),
          builder:(BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
            // print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError ) {
              return const Center(child: Text("Error"),);
            } else {

              String language = settingsState.userData['parameters']['currentLanguage'];

              return  Consumer<ColorPalette>(
                  builder: (context, palette, child) {
                    return PopScope(
                      canPop: false,
                      child: SafeArea(
                        child: Scaffold(
                            backgroundColor: palette.screenBackgroundColor,
                            body: Container(
                              color: palette.screenBackgroundColor,
                              child: Column(
                                children: [
                      
                                  const Expanded(
                                    flex: 2,  
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(flex: 1, child: SizedBox(),),
                                        Expanded(
                                          flex: 4,
                                          child: ScribbyLogoAnimation2()
                                          // child: Image(image: AssetImage('assets/images/scribby_label_1.png')),
                                          // child: ScribbyLogoAnimation()
                                        ),
                                      ],
                                    ),
                                  ),
                      
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                      
                                        MenuButtonWidget(
                                          settingsState: settingsState, 
                                          palette: palette, 
                                          language: language,
                                          body: Helpers().translateText(language, "New Game"),
                                          onPressed: () {  
                                            audioController.playSfx(SfxType.optionSelected);
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) => const GameScreen()
                                              ),
                                            );
                                            Helpers().getStates(gamePlayState, settings);         
                                          },
                                        ),
                                        MenuButtonWidget(
                                          settingsState: settingsState, 
                                          palette: palette, 
                                          language: language,
                                          body: Helpers().translateText(language, "Leaderboards"),
                                          onPressed: () {
                                            audioController.playSfx(SfxType.optionSelected);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LeaderboardsScreen()),
                                            );
                                          },
                                        ),
                                        MenuButtonWidget(
                                          settingsState: settingsState, 
                                          palette: palette, 
                                          language: language,
                                          body: Helpers().translateText(language, "Instructions"),
                                          onPressed: () {
                                            audioController.playSfx(SfxType.optionSelected);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const InstructionsScreen()),
                                            );
                                          },
                                        ),
                                        MenuButtonWidget(
                                          settingsState: settingsState, 
                                          palette: palette, 
                                          language: language,
                                          body: Helpers().translateText(language, "Settings"),
                                          onPressed: () {
                                            audioController.playSfx(SfxType.optionSelected);
                            
                                            Helpers().getStates(gamePlayState, settings);
                            
                                            bool darkMode = (settings.userData.value as Map<String, dynamic>)['parameters']['darkMode'];
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => SettingsScreen(darkMode: darkMode),
                                              ),
                                                  
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  ),
                      
                                  const SizedBox(height: 15,),
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                );
            }
          }         
        );
    //   },
    // );
  }
}



class MenuButtonWidget extends StatelessWidget {
  final SettingsState settingsState;
  final ColorPalette palette;
  final String language;
  final String body;
  final void Function()? onPressed;
  const MenuButtonWidget({
    super.key,
    required this.settingsState,
    required this.palette,
    required this.language,
    required this.body,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0 * settingsState.sizeFactor,
        8.0 * settingsState.sizeFactor,
        16.0 * settingsState.sizeFactor,
        8.0 * settingsState.sizeFactor,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 50 * settingsState.sizeFactor,
            maxWidth: 400
          ),
          decoration: BoxDecoration(
          
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                palette.optionButtonBgColor2,
                palette.optionButtonBgColor2,
              ],
              tileMode: TileMode.mirror),
                
              borderRadius: BorderRadius.all(Radius.circular(10.0 * settingsState.sizeFactor)),  
              boxShadow: const [
                BoxShadow(color: Color.fromARGB(139, 0, 0, 0), offset: Offset(3.0, 3.0), blurRadius: 5.0,)
              ]               
            ),
            



          
          child: Align(
            alignment: Alignment.center,
            child: Text(
              body,
              style: Helpers().customTextStyle(palette.optionButtonTextColor, 24*settingsState.sizeFactor),
            )
          ),
        ),                                    
      ),
    );
  }
}



