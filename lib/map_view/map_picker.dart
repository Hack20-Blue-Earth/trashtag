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

class MapPicker extends StatefulWidget {
  final LatLng initialPosition;
  MapPicker({Key key, this.initialPosition}) : super(key: key);

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  CameraPosition _cameraPosition;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Stack(
            children: [
              GoogleMap(
                onCameraMove: (value) {
                  setState(() {
                    _cameraPosition = value;
                  });
                },
                compassEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: widget.initialPosition ?? LatLng(0, 0), zoom: 10),
              ),
              Center(
                child: Icon(Icons.gps_not_fixed),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            color: Theme.of(context).dialogBackgroundColor,
            child: Text("Pick This location"),
            onPressed: () {
              Navigator.pop(context, _cameraPosition.target);
            },
          ),
        ),
      ],
    );
  }
}
