import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final VoidCallback onBack;
  const SettingsView({
    super.key,
    required this.onBack
  });

  @override
  Widget build(BuildContext context) {
  /// Builds the settings view with an independent `onBack` callback

    return Column(
      key: const ValueKey('settingsView'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack, 
              icon: Icon(Icons.arrow_back, color: Colors.white)
            ),
          ),
        ),
        const ListTile(
          title: Text("Settings Option 1", style: TextStyle(color: Colors.white)),
        ),
        const ListTile(
          title: Text("Settings Option 2", style: TextStyle(color: Colors.white)),
        ),
      ],
    );

  }
}