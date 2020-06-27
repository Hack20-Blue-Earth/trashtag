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
    return DebugScreenPicker();
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
                builder: (c) => WastePhotoScreenTest(isNew: false),
              ),
            ),
          ),
          RaisedButton(
            child: Text("Waste Gallery"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => WasteGallery(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WasteGallery extends StatelessWidget {
  final wastePinList = wastePinService.fetch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (ctx, i) => WastePinTile(wastePin: wastePinList[i]),
        itemCount: wastePinList.length,
      ),
    );
  }
}

class WastePinTile extends StatelessWidget {
  final WastePin wastePin;

  WastePinTile({Key key, this.wastePin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => WastePhotoScreenTest(preloadPin: wastePin)));
      },
      child: ListTile(
        title: Text("Loc: ${wastePin.location?.toString() ?? 'Unknown'}"),
        subtitle: Text(wastePin.note),
        leading: SizedBox(
          width: 100,
          height: 100,
          child: WastePhoto(
            wastePin: wastePin,
            disableActions: true,
          ),
        ),
      ),
    );
  }
}

extension RandomList on List<WastePin> {
  WastePin random() {
    return this[Random().nextInt(this.length)];
  }
}
