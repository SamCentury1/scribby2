import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

class DrawerAvatar extends StatelessWidget {
  const DrawerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settings, child) {

        Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
        print("user data ${settings.userData.value.toString()} ");
        File? profileImage;
        if ( userData["photoUrl"] != null ) {
          if (userData["photoUrl"] != "" && File(userData["photoUrl"]).existsSync()) {
            profileImage = File(userData["photoUrl"]);
          } 
        }
        
        Map<String,dynamic> deviceSizeInfo = settings.deviceSizeInfo.value as Map<String,dynamic>;
        final double scalor = deviceSizeInfo["scalor"];
        return SizedBox(
          width: 100,
          height: 100,
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50*scalor,
              backgroundColor: const Color.fromARGB(47, 255, 255, 255),
              foregroundColor: const Color.fromARGB(214, 243, 243, 243),
              backgroundImage: profileImage != null ? FileImage(profileImage) : null,
            ),
          ),                                
        );
      },
    );
  }
}