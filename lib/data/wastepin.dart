import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:uuid/uuid.dart";
import '../main.dart';

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
    var list = snap.documents.map((e) => WastePin.fromMap(e.data)).toList();
    Fimber.d("Loaded ${list.length} WastePins");
    return list;
  }

  void addWastePin(WastePin pin) {
    inMemoryList.add(pin);
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

  factory WastePin.fromMap(Map<String, Object> data) {
    return WastePin(
        id: data['id'],
        note: data['note'],
        category: data['category'],
        location: Location.fromMap(data['location']),
        remoteUrl: data['remoteUrl']);
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

  factory Location.fromMap(Map<String, Object> data) {
    if (data != null) {
      return Location(data['longitude'], data['latitude']);
    } else {
      return Location(0, 0);
    }
  }
}
