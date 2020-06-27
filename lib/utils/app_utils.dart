
import 'package:flutter/material.dart';


class AppUtils {
  static _NavigatorUtils _NAVIGATOR_UTILS = _NavigatorUtils();

  static _NavigatorUtils get NAVIGATOR_UTILS => _NAVIGATOR_UTILS;

  //this is used to convert the date in time stamp
  static getTimeStamp(DateTime currentDate) {
    var j = ((currentDate.millisecondsSinceEpoch) / 1000);
    var k = double.parse(j.toStringAsFixed(0)).toInt().toString();
    return k;
  }


}

class _NavigatorUtils {
// used navigator to push new screen with route name whose route is defined in
// main.dart



  navigatorPushedName(BuildContext context, String name,{dataToBeSend: dynamic})  {
    Navigator.of(context).pushNamed(name,arguments: dataToBeSend);
  }



  Future<dynamic> navigatorPushedNameResult(BuildContext context, String name,{dataToBeSend: dynamic}) async {
    return await Navigator.of(context).pushNamed(name,arguments: dataToBeSend);
  }

  // used navigator to push and replace screen if you want enter animation
  navigatorPushReplacementNamed(BuildContext context, String name,{dataToBeSend: dynamic}) {
    Navigator.of(context).pushReplacementNamed(name,arguments: dataToBeSend);
  }

  // used navigator to push and pop screen with exit animation
  navigatorPopAndPushNamed(BuildContext context, String name,{dataToBeSend: dynamic}) {
    Navigator.popAndPushNamed(context, name,arguments: dataToBeSend);
  }

  // used to clear previous all stack and pushed new screen
  //(Route<dynamic> route) => false will make sure that all routes before the
  // pushed route be removed.
  navigatorClearStack(BuildContext context, String name) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(name, (Route<dynamic> route) => false);
  }

  // used to push widget
  navigatorPushDataWithWidget(BuildContext context, Widget widget) {
    Route route =
    new MaterialPageRoute(builder: (BuildContext context) => widget);
    listContext.add(route);
    Navigator.push(context, route);
  }

  // used to clear stack with limit screen
  // if we have screen 1, screen 2 screen 3, screen 4 and i pushed screen 5 and remove until screen2 then stack will be
  // screen 1, screen 2, screen 5 -> it will remove screen 3 and 4
  navigatorClearStackWithLimit(BuildContext context, String pushedScreenName,
      String ClearRouteUntilScreenName) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        pushedScreenName, ModalRoute.withName(ClearRouteUntilScreenName));
  }









  // used navigator to pop screen if than screen can pop
  navigatorPopScreen(BuildContext context, {dataToBeSend: Object}) {
    if (Navigator.of(context).canPop()) {
      if (dataToBeSend != null)
        Navigator.of(context).pop(dataToBeSend);
      else {
        Navigator.of(context).pop();
      }
    }
  }

  // used navigator to pop screen with may be default function
  navigatorMayBePopScreen(BuildContext context, {dataToBeSend: Object}) {
    if (dataToBeSend != null) {
      Navigator.of(context).maybePop(dataToBeSend);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  // used to pop screen until pop screen
  navigatorPopUntil(BuildContext context, String popScreenTill) {
    Navigator.popUntil(context, ModalRoute.withName(popScreenTill));
  }

  List<Route> listContext = List();



}




