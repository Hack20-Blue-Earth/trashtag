import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoAlertDialog {
  static infoAlert(BuildContext context, String message, String title) {
    return
        //cupertino, default alert dialog
        showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  static infoAlertWithSingleButtonCallback(BuildContext context, String message, String title,OnPressCallbackFunction _onPressCallback) {
    return
      //cupertino, default alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                _onPressCallback();
              },
            )
          ],
        ),
      );
  }

  static infoAlertWithCallBack(BuildContext context, String message, String title, OnPressCallbackFunction _onPressCallback) {
    return
        //cupertino, default alert dialog
        showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Ok"),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pop();
              });
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Retry"),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pop();
              });
              _onPressCallback();
            },
          )
        ],
      ),
    );
  }
}

typedef OnPressCallbackFunction = void Function();
