import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/audio/audio_controller.dart';
import 'package:scribby_flutter_v2/audio/sounds.dart';

/// The button to start the game used in the gamePaused dialog
final ButtonStyle startGameButton = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 226, 124, 124),
  foregroundColor: const Color.fromARGB(255, 245, 245, 245),
  shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
  elevation: 3.0,
  minimumSize: const Size(double.infinity, 50),
  padding: const EdgeInsets.all(4.0),
  textStyle: const TextStyle(fontSize: 22,),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    side: BorderSide(
      color: Color.fromARGB(255, 245, 245, 245),
      width: 1,
      style: BorderStyle.solid
    ), 
  ),
);

final ButtonStyle gameCancel = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 241, 240, 240),
  foregroundColor: const Color.fromARGB(255, 31, 31, 31),
  shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
  elevation: 3.0,
  minimumSize: const Size(80, 40),
  padding: const EdgeInsets.all(4.0),
  textStyle: const TextStyle(fontSize: 18,),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    side: BorderSide(
      color:  Color.fromARGB(255, 61, 61, 61),
      width: 1,
      style: BorderStyle.solid
    ), 
  ),  
);

final ButtonStyle gameQuit = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 248, 170, 170),
  foregroundColor: const Color.fromARGB(255, 31, 31, 31),
  shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
  elevation: 3.0,
  minimumSize: const Size(80, 40),
  padding: const EdgeInsets.all(4.0),
  textStyle: const TextStyle(fontSize: 18,),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    side: BorderSide(
      color: Color.fromARGB(255, 61, 61, 61),
      width: 1,
      style: BorderStyle.solid
    ), 
  ),   
);

final ButtonStyle gameRestart = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 208, 255, 154),
  foregroundColor: const Color.fromARGB(255, 31, 31, 31),
  shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
  elevation: 3.0,
  minimumSize: const Size(80, 40),
  padding: const EdgeInsets.all(4.0),
  textStyle: const TextStyle(fontSize: 18,),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    side: BorderSide(
      color: Color.fromARGB(255, 61, 61, 61),
      width: 1,
      style: BorderStyle.solid
    ), 
  ),    
);


final ButtonStyle menuButton = ElevatedButton.styleFrom(

  backgroundColor: const Color.fromARGB(255, 208, 255, 154),
  foregroundColor: const Color.fromARGB(255, 31, 31, 31),
  shadowColor: const Color.fromRGBO(123, 123, 123, 0.7),
  elevation: 3.0,
  minimumSize: const Size(double.infinity, 40),
  padding: const EdgeInsets.all(4.0),
  textStyle: const TextStyle(fontSize: 28,),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    side: BorderSide(
      color: Color.fromARGB(255, 61, 61, 61),
      width: 1,
      style: BorderStyle.solid
    ), 
  ),    

);

Widget menuSelectionButton(BuildContext context, String body, Widget target) {
  return Consumer<AudioController>(
    builder: (context, audioController, child) {

      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0,16.0 ,8.0),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromARGB(255, 87, 87, 87),
                Color.fromARGB(255, 87, 87, 87),
                // const Color.fromARGB(255, 148, 148, 148),
    
              ],
              tileMode: TileMode.mirror
            ),
            border: Border(
              
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          child: InkWell(
            onTap: () {
              audioController.playSfx(SfxType.optionSelected);
              // Future.delayed(const Duration(milliseconds: 400), () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => target
                  ),
                  ModalRoute.withName('/'),
                );         
              // });
            },
            child: Align(
              alignment: Alignment.center,
              child: Text(
                body,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 235, 235, 235)
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

}
