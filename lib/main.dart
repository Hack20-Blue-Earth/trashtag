import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:wastepin/routes.dart';
import 'package:wastepin/theme/app_config.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Fimber.plantTree(FimberTree());
  Fimber.i("Starting application");

  var configuredApp = AppConfig(
    child: MyApplication(),
  );

  runZoned<Future<Null>>(() async {
    runApp(configuredApp);
  });
}


class MyApplication extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    AppConfig config = AppConfig.of(context);
    print('Calling main class first');


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WASTE PIN',
      theme: config.themeData,
      routes: MyRoutes.routes(),
    );
  }
}

