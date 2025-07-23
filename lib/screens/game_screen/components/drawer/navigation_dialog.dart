import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/initializations.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        return AlertDialog(
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          content: Text(
            widget.body,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          backgroundColor: const Color.fromARGB(255, 25, 30, 78),
          actions: <Widget>[
            TextButton(
              // style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              // style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 122, 180, 255)
              ),              
              child: const Text('Yes'),
              onPressed: widget.action
            ),
          ],
        );
      }
    );  
  }
}