import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  const MapView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(0, 0),zoom:0.0),
          ),
        ),
      ),
    );
  }
}
