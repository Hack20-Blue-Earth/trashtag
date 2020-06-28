import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatelessWidget {
  final LatLng initialPosition;
  MapPickerScreen({Key key, this.initialPosition}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick location")),
      body: MapPicker(
        initialPosition: initialPosition,
      ),
    );
  }
}

class MapPicker extends StatelessWidget {
  final LatLng initialPosition;
  MapPicker({Key key, this.initialPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      compassEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition:
          CameraPosition(target: initialPosition ?? LatLng(0, 0), zoom: 10),
    );
  }
}
