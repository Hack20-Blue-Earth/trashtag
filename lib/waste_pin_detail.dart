import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wastepin/data/wastepin.dart';

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
        ],
      ),
    );
  }
}
