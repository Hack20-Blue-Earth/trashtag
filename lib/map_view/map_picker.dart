import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
