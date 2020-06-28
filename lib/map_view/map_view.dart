import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/wastepin.dart';
import '../debug-main.dart';
import '../waste_pin_detail.dart';
import 'package:fimber/fimber.dart';
import '../splash_screen.dart';

class MapView extends StatefulWidget {
  const MapView({Key key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<WastePin> wastePinList;

  Position position;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    Fimber.d("Fetching user's location.");
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
    Fimber.d("User location: $position");
    // fetch objects
    Fimber.d("Fetching nearby WastePins");
    if (position != null) {
      wastePinList =
          await wastePinService.fetchNearby(Location.fromPosition(position));
      Fimber.d("Fetched: ${wastePinList?.length} waste pins");
      setState(() {});
    }
  }

  bool get isDataAvailable {
    return position != null && wastePinList != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: isDataAvailable
              ? GoogleMap(
                  markers: prepareMarkers(wastePinList),
                  initialCameraPosition: CameraPosition(
                    // target:                  LatLng(widget.position.latitude, widget.position.longitude),
                    target: wastePinList?.first?.location?.toLatLng() ??
                        LatLng(
                            position?.latitude ?? 0, position?.longitude ?? 0),
                    zoom: 17,
                    // bearing: position?.heading ?? 0,
                  ),
                )
              : SplashScreen(),
        ),
      ),
    );
  }

  Set<Marker> prepareMarkers(List<WastePin> wastePinList) {
    if (wastePinList == null) {
      return null;
    }
    return wastePinList
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            position: e.location.toLatLng(),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => WastePinDetail(e),
              ),
            ),
            infoWindow: InfoWindow(
              title: e.category,
              snippet: e.note,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => WastePinDetail(e),
                ),
              ),
            ),
          ),
        )
        .toSet();
  }
}
