import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:wastepin/photo/photo_screen.dart';
import '../add_waste_pin.dart';
import '../data/wastepin.dart';
import '../debug-main.dart';
import '../waste_pin_detail.dart';
import 'package:fimber/fimber.dart';
import '../splash_screen.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MapView(),
      ),
    );
  }
}

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

  addNewWastePin(BuildContext context, LatLng newPinLocation) async {
    var addNewSnackbar = SnackBar(
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: "Add Here...",
          onPressed: () async {
            var wastePin = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => AddWastePinScreen(Location(
                    newPinLocation.longitude, newPinLocation.latitude)),
              ),
            );
            Fimber.i("Added pin: $wastePin");
          },
        ),
        content: ListTile(
          title: Text("Add new Waste Pin"),
          leading: Icon(Icons.pin_drop),
        ));

    await Scaffold.of(context).showSnackBar(addNewSnackbar).closed;
    Fimber.i("Snackbar closed");
  }

  Set<Marker> prepareMarkers(List<WastePin> wastePinList) {
    if (wastePinList == null) {
      return null;
    }
    return wastePinList
        .where((element) => element.location != null)
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            position: e.location?.toLatLng(),
            onTap: () {
              showMaterialModalBottomSheet(
                context: context,
                enableDrag: true,
                expand: true,
                builder: (context, scrollController) => SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Text("Waste Pin: ${e?.location?.toString() ?? 'NA'}"),
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
                          child: WastePhoto(wastePin: e),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (c) => WastePinDetail(e),
              //   ),
              // );
            },
            infoWindow: InfoWindow(
              title: e.category,
              snippet: e.note,
              //           onTap: () async {
              //   _swiperControllerBusy = true;
              //   await _swiperController.move(i, animation: true);
              //   _swiperControllerBusy = true;
              // },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => WastePinDetail(e),
                  ),
                );
              },
            ),
          ),
        )
        .toSet();
  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  SwiperController _swiperController = SwiperController();
  bool _swiperControllerBusy = false;

  Future<void> _onIndexChanged(int index) async {
    if (wastePinList != null && !_swiperControllerBusy) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(wastePinList[index].location.latitude,
                  wastePinList[index].location.longitude),
              zoom: 18)));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    // setState(() {
      _mapController = controller;
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: isDataAvailable
            ? Stack(
                children: <Widget>[
                  Container(
                    child: GoogleMap(
                      markers: prepareMarkers(wastePinList),
                      onLongPress: (ln) => addNewWastePin(context, ln),
                      onTap: (_) {},
                      initialCameraPosition: CameraPosition(
                        // target:                  LatLng(widget.position.latitude, widget.position.longitude),
                        target: wastePinList?.first?.location?.toLatLng() ??
                            LatLng(position?.latitude ?? 0,
                                position?.longitude ?? 0),
                        zoom: 17,
                        // bearing: position?.heading ?? 0,
                      ),
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: _onMapCreated,
                      // onCameraMove: _onCameraMove,
                      zoomGesturesEnabled: true,
                      compassEnabled: false,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(Icons.location_on,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Provider.value(
                      value: wastePinList,
                      child: MapViewListWastePin(
                        onIndexChanged: _onIndexChanged,
                        swiperController: _swiperController,
                      ),
                    ),
                  )
                ],
              )
            : SplashScreen(),
      ),
    );
  }
}

class MapViewListWastePin extends StatelessWidget {
  const MapViewListWastePin(
      {Key key, this.onIndexChanged, this.swiperController})
      : super(key: key);
  final ValueChanged<int> onIndexChanged;
  final SwiperController swiperController;
  @override
  Widget build(BuildContext context) {
    var _wastePins = Provider.of<List<WastePin>>(context);

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 20,
      ),
      child: SizedBox(
        height: 175,
        width: MediaQuery.of(context).size.width,
        child: Swiper(
          itemCount: _wastePins != null ? _wastePins.length ?? 0 : 0,
          viewportFraction: 0.6,
          scale: .7,
          onIndexChanged: onIndexChanged,
          controller: swiperController,
          curve: Curves.bounceInOut,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Hero(
                tag: _wastePins[index].remoteUrl,
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  _wastePins[index].remoteUrl,
                                ),
                                fit: BoxFit.cover)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _wastePins[index].category.toString() + ' \$',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
