import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:trashtag/photo/camera_screen.dart';
import 'package:trashtag/data/wastepin.dart';
import 'package:trashtag/photo/photo_screen.dart';
import 'package:trashtag/waste_pin_detail.dart';

WastePinService wastePinService = WastePinService();

class DebugApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Debug Screen',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DebugScreenPicker(),
    );
  }
}

class DebugScreenPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          RaisedButton(
            child: Text("Photo preview Screen"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => WastePinDetail(wastePinService.fetch().first),
              ),
            ),
          ),
          RaisedButton(
            child: Text("Camera Screen"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => CameraScreen(),
              ),
            ),
          ),
          RaisedButton(
            child: Text("Image View new picker"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => WastePhotoScreenTest(),
              ),
            ),
          ),
          RaisedButton(
            child: Text("Image View update"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => WastePhotoScreenTest(false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension RandomList on List<WastePin> {
  WastePin random() {
    return this[Random().nextInt(this.length)];
  }
}
