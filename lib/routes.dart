import 'package:flutter/material.dart';

import 'debug-main.dart';
import 'map_view/map_view.dart';



class MyRoutes {

  static String INITIAL_ROUTE =
      '/'; // start screen where we fetched the data
      static String LOCAL_MAP_ROUTE = "/map";
  //static const String HOME_ROOT = '/main_repository';



  static Map<String, WidgetBuilder> routes() {
    return {
      INITIAL_ROUTE: (context) => DebugApp(),
      LOCAL_MAP_ROUTE: (c) => MapView()
      //HOME_ROOT: (context) => Home(false, false),


    };
  }
}