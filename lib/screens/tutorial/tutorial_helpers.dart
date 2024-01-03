import 'package:scribby_flutter_v2/providers/tutorial_state.dart';

class TutorialHelpers {
  Map<String, dynamic> tutorialTileState(
      int index, TutorialState tutorialState) {
    late Map<String, dynamic> tileState = tutorialState.tutorialTileState
        .firstWhere((element) => element['index'] == index);
    return tileState;
  }

  void updateTutorialTileState(
      TutorialState tutorialState, int targetIndex, String targetLetter) {
    late List<Map<String, dynamic>> newTileState =
        tutorialState.tutorialTileState;

    late Map<String, dynamic> targetObject =
        tutorialTileState(targetIndex, tutorialState);
    targetObject.update('letter', (value) => targetLetter);
    targetObject.update('active', (value) => false);

    newTileState[newTileState.indexWhere(
        (element) => element['index'] == targetIndex)] = targetObject;

    // for (Map<String,dynamic> tileItem in newTileState) {

    // }
    tutorialState.setTutorialTileState(newTileState);
  }
}
