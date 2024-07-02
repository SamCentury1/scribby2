import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';
import 'package:scribby_flutter_v2/components/scribby_logo_animation_2.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/screens/game_screen/components/play_area/decorations/decorations.dart';
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

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin{

  late bool isLoading = false;
  late AnimationController _introAnimationController1;
  late AnimationController _introAnimationController2;
  late AnimationController _introAnimationController3;
  late AnimationController _introAnimationController4;

  late Animation<double> _introAnimation1;
  late Animation<double> _introAnimation2;
  late Animation<double> _introAnimation3;
  late Animation<double> _introAnimation4;




  @override
  void initState() {
    super.initState();
    // loadAsset();


    // List<TweenSequenceItem<double>> _introAnimationSequence1 = getAnimationSequence(1, 2000, 99);
    // _introAnimation1 = TweenSequence<double>(_introAnimationSequence1).animate(_introAnimationController);

    // List<TweenSequenceItem<double>> _introAnimationSequence2 = getAnimationSequence(2, 2000, 99);
    // _introAnimation2 = TweenSequence<double>(_introAnimationSequence2).animate(_introAnimationController);

    // List<TweenSequenceItem<double>> _introAnimationSequence3 = getAnimationSequence(3, 2000, 99);
    // _introAnimation3 = TweenSequence<double>(_introAnimationSequence3).animate(_introAnimationController);

    // List<TweenSequenceItem<double>> _introAnimationSequence4 = getAnimationSequence(4, 2000, 99);
    // _introAnimation4 = TweenSequence<double>(_introAnimationSequence4).animate(_introAnimationController);

    _introAnimationController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );       
    _introAnimation1 = Tween<double>(begin: 0.0,end: 1.0,).animate(_introAnimationController1);
    Future.delayed(const Duration(milliseconds: 0), () {
      _introAnimationController1.forward();
    });

    _introAnimationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );       
    _introAnimation2 = Tween<double>(begin: 0.0,end: 1.0,).animate(_introAnimationController1);
    Future.delayed(const Duration(milliseconds: 200), () {
      _introAnimationController2.forward();
    });
    _introAnimationController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );       
    _introAnimation3 = Tween<double>(begin: 0.0,end: 1.0,).animate(_introAnimationController1);
    Future.delayed(const Duration(milliseconds: 400), () {
      _introAnimationController3.forward();
    });
    _introAnimationController4 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );       
    _introAnimation4 = Tween<double>(begin: 0.0,end: 1.0,).animate(_introAnimationController1);            
    Future.delayed(const Duration(milliseconds: 600), () {
      _introAnimationController4.forward();
    });    
    // _introAnimation1 = Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(CurvedAnimation(
    //   parent: _introAnimationController, 
    //   curve: Curves.easeInOutQuint
    //   )
    // );
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

              final double screenWidth = settingsState.screenSizeData['width'];
              final double screenHeight = settingsState.screenSizeData['height'];
              final List<Map<String,dynamic>> decorationDetails = gamePlayState.decorationData;              

              return  Consumer<ColorPalette>(
                  builder: (context, palette, child) {
                    return PopScope(
                      canPop: false,
                      child: SafeArea(
                        child: Scaffold(
                            backgroundColor: palette.screenBackgroundColor,
                            body: Stack(
                              children: [
                                CustomPaint(size: Size(screenWidth, screenHeight), painter: CustomBackground(palette: palette)),
                              
                                Decorations().decorativeSquare(decorationDetails[0]),
                                Decorations().decorativeSquare(decorationDetails[1]),
                                Decorations().decorativeSquare(decorationDetails[2]),
                                Decorations().decorativeSquare(decorationDetails[3]),
                                Decorations().decorativeSquare(decorationDetails[4]),
                                Decorations().decorativeSquare(decorationDetails[5]),
                                Decorations().decorativeSquare(decorationDetails[6]),
                                Decorations().decorativeSquare(decorationDetails[7]),
                                Decorations().decorativeSquare(decorationDetails[8]),
                                Decorations().decorativeSquare(decorationDetails[9]),
                                Decorations().decorativeSquare(decorationDetails[10]),                                
                                Positioned.fill(
                                  child: Container(
                                    // color: palette.screenBackgroundColor,
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
                                          child: Center(
                                            child: Container(
                                              width: gamePlayState.tileSize*5,
                                              height: gamePlayState.tileSize*5,
                                              child: Wrap(
                                                alignment: WrapAlignment.spaceEvenly,
                                                runSpacing: gamePlayState.tileSize*0.5,
                                                children: [
                                                  AnimatedBuilder(
                                                    animation: _introAnimationController1,
                                                    builder: (context,child) {
                                                      return AnimatedOpacity(
                                                        duration: const Duration(milliseconds: 1000),
                                                        opacity: _introAnimation1.value,
                                                        child: MenuTileWidget(
                                                          index:0,
                                                          gamePlayState: gamePlayState, 
                                                          palette: palette, 
                                                          language: language,
                                                          body: Helpers().translateText(language, "New Game",settingsState),
                                                          
                                                          iconData: Icon(
                                                            Icons.emoji_events,
                                                            size: gamePlayState.tileSize,
                                                            color: palette.fullTileTextColor
                                                          ),
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
                                                      );
                                                    },
                                                  ),
                                                  AnimatedBuilder(
                                                    animation: _introAnimationController2,
                                                    builder: (context,child) {
                                                      return AnimatedOpacity(
                                                        duration: const Duration(milliseconds: 1000),
                                                        opacity: _introAnimation2.value,
                                                        child: MenuTileWidget(
                                                          index:1,
                                                          gamePlayState: gamePlayState, 
                                                          palette: palette, 
                                                          language: language,
                                                          body: Helpers().translateText(language, "Leaderboards",settingsState),
                                                          iconData: Icon(
                                                            Icons.leaderboard,
                                                            size: gamePlayState.tileSize,
                                                            color: palette.fullTileTextColor
                                                          ),                                                    
                                                          onPressed: () {
                                                            audioController.playSfx(SfxType.optionSelected);
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const LeaderboardsScreen()),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                  AnimatedBuilder(
                                                    animation: _introAnimationController4,
                                                    builder: (context,child) {
                                                      return AnimatedOpacity(
                                                        duration: const Duration(milliseconds: 1000),
                                                        opacity: _introAnimation4.value,
                                                        child: MenuTileWidget(
                                                          index:2,
                                                          gamePlayState: gamePlayState, 
                                                          palette: palette, 
                                                          language: language,
                                                          body: Helpers().translateText(language, "Instructions",settingsState),
                                                          iconData: Icon(
                                                            Icons.notes,
                                                            size: gamePlayState.tileSize,
                                                            color: palette.fullTileTextColor
                                                          ),                                                    
                                                          onPressed: () {
                                                            audioController.playSfx(SfxType.optionSelected);
                                                            Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const InstructionsScreen()),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  ),
                                                  AnimatedBuilder(
                                                    animation: _introAnimationController3,
                                                    builder: (context,child) {
                                                      return AnimatedOpacity(
                                                        duration: const Duration(milliseconds: 1000),
                                                        opacity: _introAnimation3.value,
                                                        child: MenuTileWidget(
                                                          index:3,
                                                          gamePlayState: gamePlayState, 
                                                          palette: palette, 
                                                          language: language,
                                                          body: Helpers().translateText(language, "Settings",settingsState),
                                                          iconData: Icon(
                                                            Icons.settings,
                                                            size: gamePlayState.tileSize,
                                                            color: palette.fullTileTextColor
                                                          ),                                                    
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
                                                      );
                                                    }
                                                  ),                                                                                                                                                                               
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                                        
                                        const SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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

class MenuTileWidget extends StatelessWidget {
  final int index;
  final GamePlayState gamePlayState;
  final ColorPalette palette;
  final String language;
  final String body;
  final Icon iconData;
  final void Function()? onPressed;
  const MenuTileWidget({
    super.key,
    required this.index,
    required this.gamePlayState,
    required this.palette,
    required this.language,
    required this.body,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: gamePlayState.tileSize*2,
        height: gamePlayState.tileSize*2,
        decoration: Decorations().getTileDecoration(gamePlayState.tileSize*2, palette, index, index),
        child: Center(
          child: Container(
            width: gamePlayState.tileSize*1.5,
            height: gamePlayState.tileSize*1.5,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: iconData
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        body,
                        style: Helpers().customTextStyle(palette.fullTileTextColor, gamePlayState.tileSize*0.35),
                      ),
                    ),
                  )
                ),            
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// List<TweenSequenceItem<double>> getAnimationSequence(int index, int duration, int delay) {

//   double delay2 = 20;
//   double delayWeight = 0.01 +  (delay2 * index);
//   double middleWeight = 80.0;
//   double endWeight = 100.0 - (delayWeight + middleWeight);
//   print("delay : ${delayWeight} | middle: ${middleWeight} | end: ${endWeight}"); 
//   List<TweenSequenceItem<double>> res =  [
//     TweenSequenceItem(tween: Tween(begin:0.0, end: 0.0,), weight: delayWeight),
//     TweenSequenceItem(tween: Tween(begin:0.0, end: 1.0,), weight: middleWeight),    
//     TweenSequenceItem(tween: Tween(begin:1.0, end: 1.0,), weight: endWeight),           
//   ];
//   return res; 
// }    
