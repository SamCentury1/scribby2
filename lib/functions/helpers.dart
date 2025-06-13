import 'dart:math';

import 'package:scribby_flutter_v2/settings/settings.dart';

class Helpers {

  double getScalor(SettingsController settings) {
    final Map<dynamic,dynamic> deviceSizeData = settings.deviceSizeInfo.value as Map<dynamic,dynamic>;
    final scalor = deviceSizeData["scalor"];
    print("in the getScalor funciton: $deviceSizeData | $scalor");
    return scalor;  
  }

  String generateRandomUsername() {
    final adjectives = [
      'Adventurous', 'Brave', 'Curious', 'Daring', 'Eager',
      'Fancy', 'Gentle', 'Happy', 'Icy', 'Jolly',
      'Kind', 'Lucky', 'Mighty', 'Nimble', 'Odd',
      'Proud', 'Quick', 'Royal', 'Sharp', 'Tough',
      'Unique', 'Vivid', 'Witty', 'Young', 'Zany'
    ];

    final nouns = [
      'Hawk', 'Panther', 'Battleship', 'Scissors', 'Mountain',
      'Falcon', 'Tiger', 'Tornado', 'Planet', 'Shadow',
      'Volcano', 'Puzzle', 'Wizard', 'Comet', 'Dragon',
      'Helmet', 'Rocket', 'Anchor', 'Beacon', 'Whale',
      'Jungle', 'Saber', 'Knight', 'Lantern', 'Phoenix'
    ];

    final random = Random();
    final adjective = adjectives[random.nextInt(adjectives.length)];
    final noun = nouns[random.nextInt(nouns.length)];

    return '$adjective $noun';
  }  

}