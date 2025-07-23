import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/providers/game_play_state.dart';

class ShopView extends StatelessWidget {
  final VoidCallback onBack;
  const ShopView({
    super.key,
    required this.onBack
  });

  @override
  Widget build(BuildContext context) {
  /// Builds the settings view with an independent `onBack` callback

    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double scalor = gamePlayState.scalor;
        return Column(
          key: const ValueKey('shopView'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150 * scalor,
              child: Row(
                // alignment: Alignment.centerLeft,
                children: [
                  IconButton(
                    onPressed: onBack, 
                    icon: Icon(Icons.arrow_back, color: Colors.white ),
                    iconSize: 34 * scalor,
                  ),
                  Text("Shop", style: TextStyle(color: Colors.white, fontSize: 26*scalor),)
                ] 
              ),
            ),
            const ListTile(
              title: Text("Shop Option 1", style: TextStyle(color: Colors.white)),
            ),
            const ListTile(
              title: Text("Shop Option 2", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }
    );

  }
}