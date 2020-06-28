import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:wastepin/map_view/map_view.dart';
import 'package:wastepin/on_boarding.dart';
import 'package:wastepin/photo/camera_screen.dart';
import 'package:wastepin/data/wastepin.dart';
import 'package:wastepin/photo/photo_screen.dart';
import 'package:wastepin/waste_pin_detail.dart';

import 'add_waste_pin.dart';

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
                builder: (c) => WastePinDetail(wastePinService.inMemoryList.first),
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
            child: Text("Add New Location"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => AddWastePinScreen(),
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
           RaisedButton(
            child: Text("Map View"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => MapView(),
              ),
            ),
          ),
           RaisedButton(
            child: Text("On Boarding"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => OnBoarding(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WasteGallery extends StatelessWidget {
  final wastePinList = wastePinService.inMemoryList;

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
