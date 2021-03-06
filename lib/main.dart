import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wastepin/routes.dart';
import 'package:wastepin/theme/app_config.dart';
import 'splash_screen.dart';

import 'data/wastepin.dart';
import 'debug-main.dart';
import 'map_view/map_view.dart';
import 'theme/custom_theme.dart';

final firestoreInstance = Firestore.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Fimber.plantTree(FimberTree());
  Fimber.i("Starting application");

  var configuredApp = AppConfig(
    child: WasteBinApp(),
    themeData: myCustomTheme,
  );

  runZoned<Future<Null>>(() async {
    runApp(configuredApp);
  });
}

class WasteBinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context);
    print('Calling main class first');

    return MaterialApp(
      title: "Waste Bin",
      debugShowCheckedModeBanner: false,
      theme: config.themeData,
      routes: MyRoutes.routes(),
    );
  }
}

