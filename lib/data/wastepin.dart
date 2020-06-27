
import "package:uuid/uuid.dart";
import 'package:uuid/uuid_util.dart';


class WastePinService {
  List<WastePin> _inMemoryList;

  WastePinService() {

// Temporary generation
    _inMemoryList = List.generate(10, (index) => WastePin(note: "Waste test: $index", location:Location(-80+((index%3)*0.01), 40+((index/3)*0.01))));
    
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
    var inMemory = _inMemoryList.firstWhere((element) => (element.id==pin.id), orElse: ()=>null);
    if (inMemory!=null) {
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

  WastePin({this.id, this.note, this.localFilePath, this.location}){
    if (this.id==null) {
      this.id = Uuid().v1(options:location?.toMap());
    }
  }

}


class Location {
  double longitude;
  double latitude;
  Location(this.longitude, this.latitude);

  Map<String,double> toMap() {
    return {
      "longitude":longitude,
      "latitude":latitude
    }
  }
}