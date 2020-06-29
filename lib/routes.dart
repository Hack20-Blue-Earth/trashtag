import 'package:flutter/material.dart';
import 'package:wastepin/issue_screen.dart';
import 'package:wastepin/on_boarding.dart';
import 'package:wastepin/splash_screen.dart';

import 'debug-main.dart';
import 'map_view/map_view.dart';



class MyRoutes {

  static String INITIAL_ROUTE =
      '/'; // start screen where we fetched the data
      static String LOCAL_MAP_ROUTE = "/map";
  static const String ONBOARDING_ROOT = '/onboarding_root';
  static const String ISSUE_ROOT = '/issue_root';



  static Map<String, WidgetBuilder> routes() {
    return {
      INITIAL_ROUTE: (context) => SplashScreen(),
      LOCAL_MAP_ROUTE: (c) => MapView(),
      ONBOARDING_ROOT: (context) => OnBoarding(),
      ISSUE_ROOT: (context) => IssueScreen(),


    };
  }
}