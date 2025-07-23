// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scribby_flutter_v2/ads/ads_controller.dart';

import 'package:scribby_flutter_v2/main.dart';
import 'package:scribby_flutter_v2/settings/persistence/local_storage_settings_persistence.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    AdsController? adsController;
    if (kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      adsController = AdsController(MobileAds.instance);
      adsController.initialize();
    }    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      settingsPersistence: LocalStorageSettingsPersistence(),
      adsController: adsController,
    ));


    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
