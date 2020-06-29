import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
<<<<<<< HEAD
import 'package:wastepin/issue_listing_detail_screen.dart';
import 'package:wastepin/issue_listing_screen.dart';
import 'package:wastepin/photo/photo_screen.dart';
=======
import 'package:wastepin/issue_screen.dart';
import 'package:wastepin/loading_screen.dart';
>>>>>>> c85af7a2a0cee1fb935b72dc0eb40ac929092815
import 'package:wastepin/theme/custom_theme.dart';
import '../add_waste_pin.dart';
import '../data/wastepin.dart';
import '../debug-main.dart';
import '../waste_pin_detail.dart';
import 'package:fimber/fimber.dart';
import '../splash_screen.dart';

class MapScreen extends StatelessWidget {

  List<WastePin> _wastePinList;

  MapScreen(this._wastePinList);

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
  ValueNotifier _index = ValueNotifier<int>(0);

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
          textColor: colorAccent,
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
    Fimber.d("wastePinList" + wastePinList.length.toString());

    wastePinList =
        wastePinList.where((element) => element.location != null).toList();
    Fimber.d("wastePinList" + wastePinList.length.toString());

    return wastePinList.fold<List<Marker>>(
      [],
      (list, e) => list
        ..add(Marker(
          markerId: MarkerId(e.id),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: e.location?.toLatLng(),
          onTap: () async {
            // _panelController.open();

            // _swiperControllerBusy = true;
            // await _swiperController.move(list.length-1,
            //     animation: true);
            // _swiperControllerBusy = false;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => IssueListingDetailScreen(e),
              ),
            );
            // showMaterialModalBottomSheet(
            //   context: context,
            //   enableDrag: true,
            //   expand: true,
            //   builder: (context, scrollController) => SizedBox(
            //     height: 100,
            //     child: Column(
            //       children: [
            //         Text("Waste Pin: ${e?.location?.toString() ?? 'NA'}"),
            //         Text(
            //             "Location and photo with notes, map and future comment section goes here"),
            //         AspectRatio(
            //           aspectRatio: 1.666,
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.black,
            //               border: Border.all(
            //                 color: Colors.blue,
            //               ),
            //               borderRadius: BorderRadius.circular(10.0),
            //             ),
            //             child: WastePhoto(wastePin: e),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (c) => WastePinDetail(e),
            //   ),
            // );
          },
          infoWindow: InfoWindow(
            title: e.category,
            snippet: e.note,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => IssueListingDetailScreen(e),
                ),
              );
            },
          ),
        )),
    ).toSet();
  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  SwiperController _swiperController = SwiperController();
  PanelController _panelController = PanelController();
  bool _swiperControllerBusy = false;

  Future<void> _onIndexChanged(int index) async {
    _index.value = (index);
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
      body: isDataAvailable
          ? SlidingUpPanel(
              boxShadow: [],
              maxHeight: MediaQuery.of(context).size.height * 0.37, // 0.85,
              minHeight: MediaQuery.of(context).size.height * 0.37,
              panelSnapping: true,
              controller: _panelController,
              color: Colors.transparent,
              panel: Container(
                child: Provider.value(
                  value: wastePinList,
                  child: MapViewListWastePin(
                      onIndexChanged: _onIndexChanged,
                      swiperController: _swiperController,
                      index: _index),
                ),
              ),
              body: Builder(builder: (context) {
                return Center(
                    child: Stack(
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
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Icon(Icons.location_on,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ));
              }),
            )
          : LoadingScreen(),
    );
  }
}

class MapViewListWastePin extends StatelessWidget {
  const MapViewListWastePin(
      {Key key, this.onIndexChanged, this.swiperController, this.index})
      : super(key: key);
  final ValueChanged<int> onIndexChanged;
  final SwiperController swiperController;
  final ValueNotifier<int> index;
  @override
  Widget build(BuildContext context) {
    var _wastePins = Provider.of<List<WastePin>>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.37, // * 0.75,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: MyCustomTheme.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 22,
          ),
          Material(
            shape: StadiumBorder(),
            color: MyCustomTheme.colorGreyText,
            child: Container(
              height: 5,
              width: 134,
            ),
          ),
          SizedBox(
            height: 22,
          ),
          SizedBox(
            height: 175,
            width: MediaQuery.of(context).size.width,
            child: Swiper(
              itemCount: _wastePins != null ? _wastePins.length ?? 0 : 0,
              viewportFraction: 0.7,
              scale: 1,
              onIndexChanged: onIndexChanged,
              controller: swiperController,
              curve: Curves.bounceInOut,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) =>
                          IssueListingDetailScreen(_wastePins[index]),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Material(
                      elevation: 4,
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                  imageUrl: _wastePins[index].remoteUrl,
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: SizedBox(
                                      height: 40,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 2,
                                            //#F8F8F8
                                            color: Colors.white.withAlpha(150),
                                          ),
                                          Container(
                                            height: 38,
                                            //#3023B1
                                            color: MyCustomTheme.primaryColor
                                                .withAlpha(150),
                                            child: Center(
                                              child: Text(
                                                _wastePins[index]
                                                    .note
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
          // SizedBox(
          //   height: 30,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: ValueListenableBuilder<int>(
          //       valueListenable: index,
          //       builder: (_, _index, ___) {
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.stretch,
          //           children: <Widget>[
          //             Material(
          //               shape: StadiumBorder(),
          //               color: MyCustomTheme.colorAccentDark,
          //               child: Container(
          //                 height: 3,
          //               ),
          //             ),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Text(
          //               'Location:',
          //               style: TextStyle(
          //                 fontSize: 15,
          //                 height: 1.2,
          //               ),
          //             ),
          //             SizedBox(
          //               height: 5,
          //             ),
          //             Row(
          //               children: <Widget>[
          //                 Expanded(
          //                   child: TextField(
          //                     enabled: false,
          //                     decoration: InputDecoration(
          //                       isDense: true,
          //                       disabledBorder: OutlineInputBorder(
          //                           borderSide: BorderSide(
          //                               color: MyCustomTheme.colorPrimary)),
          //                       border: OutlineInputBorder(),
          //                       labelText: 'Lat: ' +
          //                           _wastePins[_index]
          //                               ?.location
          //                               ?.latitude
          //                               ?.toString()
          //                               .substring(0, 7),
          //                     ),
          //                   ),
          //                 ),
          //                                           SizedBox(width:20),

          //                 Material(
          //                   color: MyCustomTheme.primaryColor,
          //                   shape: StadiumBorder(),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(10),
          //                     child: Icon(Icons.my_location, size: 40,color: Colors.white,),
          //                   ),
          //                 ),
          //                 SizedBox(width:20),
          //                 Expanded(
          //                   child: TextField(
          //                     enabled: false,
          //                     decoration: InputDecoration(
          //                       isDense: true,
          //                       disabledBorder: OutlineInputBorder(
          //                           borderSide: BorderSide(
          //                               color: MyCustomTheme.colorPrimary)),
          //                       border: OutlineInputBorder(),
          //                       labelText: 'Lng: ' +
          //                           _wastePins[_index]
          //                               ?.location
          //                               ?.latitude
          //                               ?.toString()
          //                               .substring(0, 7),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             SizedBox(
          //               height: 20,
          //             ),
          //             Text(
          //               'Date Added:',
          //               style: TextStyle(
          //                 fontSize: 15,
          //                 height: 1.2,
          //               ),
          //             ),
          //             SizedBox(
          //               height: 5,
          //             ),
          //             Row(
          //               children: <Widget>[
          //                 Expanded(
          //                   child: TextField(
          //                     enabled: false,
          //                     decoration: InputDecoration(
          //                       isDense: true,
          //                       disabledBorder: OutlineInputBorder(
          //                           borderSide: BorderSide(
          //                               color: MyCustomTheme.colorPrimary)),
          //                       border: OutlineInputBorder(),
          //                       labelText: 'Lat:' +
          //                           _wastePins[_index]
          //                               .note

          //                               ?.toString(),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             SizedBox(
          //               height: 20,
          //             ),
          //             FlatButton(
          //               child: Text(
          //                 "Picked Up Now",
          //                 style: TextStyle(
          //                   fontSize: 17,
          //                 ),
          //               ),
          //               color: MyCustomTheme.primaryColor,
          //               textColor: MyCustomTheme.backgroundColor,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //               ),
          //               onPressed: () {},
          //             ),
          //             SizedBox(
          //               height: 20,
          //             ),
          //           ],
          //         );
          //       }),
          // ),
        ],
      ),
    );
  }
}
