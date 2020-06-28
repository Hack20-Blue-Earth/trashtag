import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:uuid/uuid.dart";
import '../main.dart';

import 'package:image/image.dart' as ImageCoding;

var wildWastePhotos = [
  'https://thedailynews.cc/wp-content/uploads/2017/09/loc-0928-ew-park-trash-3.jpg',
  'https://s.hdnux.com/photos/34/77/76/7602051/5/gallery_medium.jpg',
  'https://image.shutterstock.com/image-photo/environmental-problems-garbage-forest-600w-1706577346.jpg',
  'https://eco-business.imgix.net/uploads/ebmedia/fileuploads/20170823_vai_beacheastcoastpark.jpg?fit=crop&h=960&ixlib=django-1.2.0&w=1440',
  'https://image.shutterstock.com/image-photo/pollution-concept-garbage-rubbish-waste-600w-1608042094.jpg',
  'https://image.shutterstock.com/image-photo/forest-pollution-dump-garbage-woods-600w-1730292784.jpg',
  'https://image.shutterstock.com/image-photo/wild-dump-hazardous-waste-electronic-600w-1671125371.jpg',
  'https://image.shutterstock.com/image-photo/phitsanulokthailand-may-11-2019-old-600w-1556745764.jpg',
  'https://image.shutterstock.com/image-photo/illegal-garbage-thrown-out-forest-260nw-1664704984.jpg',
  'https://image.shutterstock.com/image-photo/transcarpathia-ukraine-august-8-2016-600w-468544031.jpg'
];

class WastePinService {
  List<WastePin> inMemoryList;

  WastePinService() {
// Temporary generation
    inMemoryList = List.generate(
        wildWastePhotos.length,
        (index) => WastePin(
            remoteUrl: wildWastePhotos[index],
            note: "Waste test: $index",
            location: Location(
                -80 + ((index % 3) * 0.01), 40 + ((index / 3) * 0.01))));
  }

  Future<List<WastePin>> fetch() async {
    // TODO connect to API and fetch
    return inMemoryList;
  }

  Future<List<WastePin>> fetchNearby(Location location) async {
    Fimber.d("Loading data from Firestore.");
    var snap = await firestoreInstance.collection('wastepins').getDocuments();
    var list = snap.documents.map((e) => WastePin.fromJson(e.data)).toList();
    Fimber.d("Loaded ${list.length} WastePins");
    return list;
  }

  Future<String> uploadPhoto(WastePin pin) async {
    // todo upload
    StorageReference storageReference =
        FirebaseStorage(storageBucket: 'gs://hack20-wastepin.appspot.com')
            .ref()
            .child("${pin.id}");

    Fimber.d("About up upload file: ${storageReference.path}");
    ImageCoding.Image _image =
        ImageCoding.decodeImage(File(pin.localFilePath).readAsBytesSync());
    // ImageCoding.Image _thumbnail = ImageCoding.copyResize(_image, width: 640);
    _image = ImageCoding.copyResize(_image, width: 1360);

    var _uploadTask =
        storageReference.putData(ImageCoding.encodeJpg(_image, quality: 80));

    await _uploadTask.onComplete;

    String downloadUrl = await _uploadTask.lastSnapshot.ref.getDownloadURL();
    Fimber.d("Image uploaded : url=> $downloadUrl");

    pin.remoteUrl = downloadUrl;
    return downloadUrl;
  }

  Future<void> addWastePin(
    WastePin pin,
  ) async {
    Fimber.i('Adding waste pin. :$pin');
    if (pin.localFilePath != null && pin.remoteUrl == null) {
      // upload pin photo
      var remoteUrl = await uploadPhoto(pin);
      pin.remoteUrl = remoteUrl;
    }

    var docRef =
        await firestoreInstance.collection('wastepins').add(pin.toJson());
    var createdPin = WastePin.fromJson((await docRef.get()).data);
    inMemoryList.add(createdPin);
    return createdPin;
  }

  void updateWastePin(WastePin pin) {
    // faking update to server and local
    var inMemory = inMemoryList.firstWhere((element) => (element.id == pin.id),
        orElse: () => null);
    if (inMemory != null) {
      inMemory.localFilePath = pin.localFilePath;
      inMemory.location = pin.location;
      inMemory.note = pin.note;
      inMemory.remoteUrl = pin.remoteUrl;
    }
  }
}

class WastePin {
  static var categoryTrashOverflow = "Trash overflow";

  String id;
  String category = categoryTrashOverflow;
  String note;
  String localFilePath; // it could be asset too
  String remoteUrl;
  Location location;

  WastePin(
      {this.id,
      this.note,
      this.category,
      this.localFilePath,
      this.location,
      this.remoteUrl}) {
    if (this.id == null) {
      this.id = Uuid().v1(options: location?.toMap());
    }
  }

  factory WastePin.fromJson(Map<String, dynamic> json) => WastePin(
        id: json["id"] == null ? null : json["id"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        note: json["note"] == null ? null : json["note"],
        category: json["category"] == null ? null : json["category"],
        remoteUrl: json["remoteUrl"] == null ? null : json["remoteUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "location": location == null ? null : location.toJson(),
        "note": note == null ? null : note,
        "category": category == null ? null : category,
        "remoteUrl": remoteUrl == null ? null : remoteUrl,
      };

  @override
  String toString() {
    return "WastePin: $id, loc:$location, $note, url:$remoteUrl";
  }
}

class Location {
  double longitude;
  double latitude;
  Location(this.longitude, this.latitude);

  @override
  String toString() {
    return "Geo(${longitude.toStringAsFixed(3)}, ${latitude.toStringAsFixed(3)});";
  }

  Map<String, double> toMap() {
    return {"longitude": longitude, "latitude": latitude};
  }

  factory Location.fromPosition(Position userPosition) {
    return Location(userPosition.longitude, userPosition.latitude);
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  factory Location.fromLatLng(LatLng latLng) {
    if (latLng == null) return null;
    return Location(latLng.longitude, latLng.latitude);
  }

  factory Location.fromMap(Map<String, Object> data) {
    if (data != null) {
      return Location(data['longitude'], data['latitude']);
    } else {
      return Location(0, 0);
    }
  }

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        json["longitude"] == null ? null : json["longitude"].toDouble(),
        json["latitude"] == null ? null : json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude == null ? null : longitude,
        "latitude": latitude == null ? null : latitude,
      };
}
