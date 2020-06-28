import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wastepin/photo/photo_screen.dart';

class AddWastePinScreen extends StatelessWidget {

  // TODO add pin operations and state widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waste pin - add")),
      body: ListView(
        children: [
          Text("Add new Waste Pin"),
          AspectRatio(
              aspectRatio: 1.6666,
              child: WastePhoto(
                downloadAvailable: false,
                wastePin: null,
              )),
        ],
      ),
    );
  }
}
