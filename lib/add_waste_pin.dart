import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wastepin/map_view/map_view.dart';
import 'package:wastepin/photo/photo_screen.dart';
import 'package:wastepin/splash_screen.dart';
import 'package:wastepin/waste_pin_detail.dart';

import 'custom_widgets/info_alert_dialog.dart';
import 'data/wastepin.dart';
import 'map_view/map_picker.dart';

class AddWastePinScreen extends StatefulWidget {
  final Location _initialLocation;
  AddWastePinScreen([this._initialLocation]);

  @override
  _AddWastePinScreenState createState() => _AddWastePinScreenState();
}

class _AddWastePinScreenState extends State<AddWastePinScreen> {
  TextEditingController _textEditingController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _photoFilePath;

  Location pinLocation;

  pickLocation(BuildContext context) async {
    Fimber.d("Pick location on map.");
    LatLng pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapPickerScreen(
          initialPosition: pinLocation?.toLatLng(),
        ),
      ),
    );
    if (pickedLocation != null) {
      setState(() {
        pinLocation = Location.fromLatLng(pickedLocation);
      });
    }
  }

  userCurrentLocation() {
    Fimber.d("Fetching user's location.");
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      Fimber.d("User location: $value");
      if (value != null) {
        setState(() {
          pinLocation = Location.fromPosition(value);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pinLocation = widget._initialLocation;
  }

  void pickedPhoto(String path, bool tookPhoto) {
    if (tookPhoto) {
      userCurrentLocation();
    }
    setState(() {
      _photoFilePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Waste Pin")),
      body: (_isLoading)
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: ListView(
                  children: [
                    AspectRatio(
                        aspectRatio: 1.6666,
                        child: WastePhoto(
                          pickedFileCallback: pickedPhoto,
                          downloadAvailable: false,
                          wastePin: null,
                        )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: (pinLocation == null)
                          ? ButtonBar(
                              alignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlatButton.icon(
                                  icon: Icon(Icons.gps_fixed),
                                  label: Text("Use current Locaton"),
                                  onPressed: userCurrentLocation,
                                ),
                                FlatButton.icon(
                                  icon: Icon(Icons.map),
                                  label: Text("Pick from Map"),
                                  onPressed: () => pickLocation(context),
                                )
                              ],
                            )
                          : FlatButton(
                              onPressed: () => pickLocation(context),
                              child: Text("Change Location: $pinLocation"),
                            ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _textEditingController,
                        maxLines: 5,
                        validator: (value) {
                          print("Validator called");
                          if (value == null ||
                              (value != null && value.isEmpty)) {
                            return "Field should not be empty!";
                          } else
                            return null;
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
//                focusedBorder: InputBorder.none,
//                enabledBorder: InputBorder.none,
//                errorBorder: InputBorder.none,
//                disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Enter your Notes here..."),
                      ),
                    )
                  ],
                ),
              ),
            ),
      persistentFooterButtons: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            elevation: 0.0,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
                side: BorderSide(color: Colors.blue)),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                WastePin pin = WastePin(
                    location: pinLocation,
                    localFilePath: _photoFilePath,
                    note: _textEditingController.text.trim());
                setState(() {
                  _isLoading = true;
                });

                WastePinService().addWastePin(pin).then((value) async {
                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.pop(context, value);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => WastePinDetail(value)));
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
              child: Text(
                "SUBMIT",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
