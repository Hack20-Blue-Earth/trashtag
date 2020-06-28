import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isDataAvailable
          ? Provider.value(value: wastePinList, child: MyHomePage())
          // GoogleMap(
          //     onLongPress: (ln) => addNewWastePin(context, ln),
          //     markers: prepareMarkers(wastePinList),
          //     initialCameraPosition: CameraPosition(
          //       // target:                  LatLng(widget.position.latitude, widget.position.longitude),
          //       target: wastePinList?.first?.location?.toLatLng() ??
          //           LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
          //       zoom: 17,
          //       // bearing: position?.heading ?? 0,
          //     ),
          //   )
          : SplashScreen(),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  SwiperController _swiperController = SwiperController();
  bool _swiperControllerBusy = false;

  Future<void> _onIndexChanged(int index) async {
    //final GoogleMapController controller = await _controller.future;

    //_mapController.animateCamera(CameraUpdate.newCameraPosition());

    // final GoogleMapController controller = await _controller.future;
    if (_wastePins != null && !_swiperControllerBusy) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(_wastePins[index].location.latitude,
                  _wastePins[index].location.longitude),
              //tilt: 59.440717697143555,
              zoom: 18)));
      //_mapController.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(35.5609356, 45.4123512),
      //tilt: 59.440717697143555,
      zoom: 18);

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(35.5609356, 45.4123512),
      // tilt: 59.440717697143555,
      zoom: 18);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _mapController = controller;
    });
  }

  Set<Marker> _markers = Set();
  List<WastePin> _wastePins;

  void _addMarker() {
    //  _markers.add(
    //       Marker(
    //           markerId: MarkerId(_lastMapPosition.toString()),
    //           position: _lastMapPosition,
    //           infoWindow: InfoWindow(
    //               title: "Pizza Parlour",
    //               snippet: "This is a snippet",
    //               onTap: (){
    //               }
    //           ),
    //           onTap: (){
    //           },

    //           icon: BitmapDescriptor.defaultMarker));

//  Future.microtask(() =>
//     Provider.of<List<WastePin>>(context,listen: true);
//   );

    if (_wastePins != null) {
      _markers.clear();
      for (var i = 0; i < _wastePins.length; i++) {
        var __wastePin = _wastePins[i];
        _markers.add(Marker(
            markerId: MarkerId(__wastePin.id.toString()),
            position: LatLng(
                __wastePin.location.latitude, __wastePin.location.longitude),
            infoWindow: InfoWindow(
                title: __wastePin.category.toString(),
                //snippet: ,

                onTap: () {}),
            onTap: ()  async{
              _swiperControllerBusy = true;
              await _swiperController.move(i, animation: true);
                            _swiperControllerBusy = true;

              },
            icon: BitmapDescriptor.defaultMarker
            // BitmapDescriptor.fromAssetImage(configuration, assetName)
            ));
        setState(() {});
      }
    }

//             _markers.addAll(_wastePins.map((__wastePin){

// return Marker(
//               markerId: MarkerId(_lastMapPosition.toString()),
//               position: LatLng(__wastePin.latitude,__wastePin.longitude),
//               infoWindow: InfoWindow(
//                   title: __wastePin.price.toString(),
//                   //snippet: ,

//                   onTap: (){
//                   }
//               ),
//               onTap: (){
//               },

//               icon: BitmapDescriptor.defaultMarker);

//             }));
// }
  }

  // _onCameraMove(CameraPosition position) {
  //   print(position.target);
  // }

  @override
  Widget build(BuildContext context) {
    _wastePins = Provider.of<List<WastePin>>(context, listen: true);
    _addMarker();

    return Scaffold(
      body: Builder(builder: (context) {
        return Material(
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  child: GoogleMap(
                    markers: Set<Marker>.of(_markers),
                    initialCameraPosition: _kGooglePlex,
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
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainPageSliderAndFliters(
                              myLocationPressed: _goToTheLake,
                              addPressed: () {
                                double h = MediaQuery.of(context).size.height -
                                    MediaQuery.of(context).padding.top;
                                // showStopper()
                              }),
                        ),
                        MainPageListWastePin(
                          onIndexChanged: _onIndexChanged,
                          swiperController: _swiperController,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    //_mapController.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }
}

class MainPageSliderAndFliters extends StatefulWidget {
  MainPageSliderAndFliters(
      {Key key, @required this.addPressed, @required this.myLocationPressed})
      : super(key: key);

  final VoidCallback addPressed;
  final VoidCallback myLocationPressed;

  @override
  _MainPageSliderAndFlitersState createState() =>
      _MainPageSliderAndFlitersState();
}

class _MainPageSliderAndFlitersState extends State<MainPageSliderAndFliters> {
  RangeValues _selectedRange = RangeValues(0, 1000);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                LimitedBox(
                  maxWidth: 335,
                  maxHeight: 40,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned.directional(
                        start: -15,
                        width: 365,
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Theme.of(context).primaryColor,
                            thumbColor: Theme.of(context).primaryColor,
                            trackHeight: 14,
                            //rangeThumbShape: RangeSliderThumbShape().paint(context, Offset.zero),
                            showValueIndicator: ShowValueIndicator.always,
                          ),
                          child: RangeSlider(
                            onChanged: (RangeValues value) {
                              setState(() => _selectedRange = value);
                            },
                            values: _selectedRange,
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            labels: RangeLabels('${_selectedRange.start}D',
                                '${_selectedRange.end}D'),
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 40,
                  child: Card(
                    color: Colors.white70,
                    shape: StadiumBorder(),
                    child: DefaultTabController(
                      length: 2,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        indicator: CustomTabIndicator(),
                        unselectedLabelColor: Colors.blueGrey,
                        tabs: <Widget>[
                          Tab(
                            child: Text(
                              'Buy',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Rent',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 260,
                  height: 40,
                  child: Card(
                    color: Colors.white70,
                    shape: StadiumBorder(),
                    child: DefaultTabController(
                      length: 4,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        indicator: CustomTabIndicator(),
                        unselectedLabelColor: Colors.blueGrey,
                        tabs: <Widget>[
                          Tab(
                            child: Text(
                              'Land',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Shop',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Aparment',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'House',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 40,
              width: 40,
              child: Card(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.zero,
                elevation: 4,
                shape: StadiumBorder(),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.my_location),
                  onPressed: widget.myLocationPressed,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: Card(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.zero,
                elevation: 4,
                shape: StadiumBorder(),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.add),
                  onPressed: widget.addPressed,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return new _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final Rect rect =
        Offset(offset.dx, (configuration.size.height / 2) - 30 / 2) &
            Size(configuration.size.width, 30);

    //final Rect rect = offset & configuration.size;
    final Paint paint = Paint();
    paint.color = Color(0xFF5564FF);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(10.0)), paint);
  }
}

class MainPageListWastePin extends StatelessWidget {
  const MainPageListWastePin(
      {Key key, this.onIndexChanged, this.swiperController})
      : super(key: key);
  final ValueChanged<int> onIndexChanged;
  final SwiperController swiperController;
  @override
  Widget build(BuildContext context) {
    var _wastePins = Provider.of<List<WastePin>>(context);

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 20,
        ),
        height: 175,
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
