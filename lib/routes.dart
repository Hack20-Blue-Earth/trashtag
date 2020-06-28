import 'package:flutter/material.dart';

import 'debug-main.dart';



class MyRoutes {

  static String INITIAL_ROUTE =
      '/'; // start screen where we fetched the data
  //static const String HOME_ROOT = '/main_repository';



  static Map<String, WidgetBuilder> routes() {
    return {
      INITIAL_ROUTE: (context) => DebugApp(),
      //HOME_ROOT: (context) => Home(false, false),


    };
  }
}