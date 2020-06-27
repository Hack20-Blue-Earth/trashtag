import "package:uuid/uuid.dart";
import 'package:uuid/uuid_util.dart';

var wildWastePhotos=[
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
  List<WastePin> _inMemoryList;

  WastePinService() {
// Temporary generation
    _inMemoryList = List.generate(
        wildWastePhotos.length,
        (index) => WastePin(
            remoteUrl: wildWastePhotos[index],
            note: "Waste test: $index",
            location: Location(
                -80 + ((index % 3) * 0.01), 40 + ((index / 3) * 0.01))));
  }

  List<WastePin> fetch() {
    // TODO connect to API and fetch
    return _inMemoryList;
  }

  void addWastePin(WastePin pin) {
    _inMemoryList.add(pin);
  }

  void updateWastePin(WastePin pin) {
    // faking update to server and local
    var inMemory = _inMemoryList.firstWhere((element) => (element.id == pin.id),
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
  String id;
  String note;
  String localFilePath; // it could be asset too
  String remoteUrl;
  Location location;

  WastePin({this.id, this.note, this.localFilePath, this.location, this.remoteUrl}) {
    if (this.id == null) {
      this.id = Uuid().v1(options: location?.toMap());
    }
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
}
