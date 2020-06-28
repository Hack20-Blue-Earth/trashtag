import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wastepin/data/wastepin.dart';
import 'photo/photo_screen.dart';

class WastePinDetail extends StatelessWidget {
  final WastePin wastePin;

  WastePinDetail(this.wastePin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waste Pin: ${wastePin?.location?.toString() ?? 'NA'}"),
      ),
      body: Column(
        children: [
          Text(
              "Location and photo with notes, map and future comment section goes here"),
          AspectRatio(
            aspectRatio: 1.666,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: WastePhoto(wastePin: wastePin),
            ),
          ),
        ],
      ),
    );
  }
}
