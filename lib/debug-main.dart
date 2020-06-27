import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:trashtag/camera/camera_screen.dart';
import 'package:trashtag/data/wastepin.dart';
import 'package:trashtag/waste_pin_detail.dart';

void main() {
  Fimber.plantTree(FimberTree());
  Fimber.i("Starting application");
  runApp(DebugApp());
}

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
  var 
  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}
