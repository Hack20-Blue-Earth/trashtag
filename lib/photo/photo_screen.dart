import 'dart:io';
import 'dart:math';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastepin/data/wastepin.dart';
import 'package:wastepin/theme/custom_theme.dart';

import '../debug-main.dart';

class WastePhotoScreenTest extends StatelessWidget {
  final bool isNew;
  final WastePin preloadPin;

  WastePhotoScreenTest({this.isNew = true, this.preloadPin});

  @override
  Widget build(BuildContext context) {
    WastePin wastePin;
    if (!isNew) {
      wastePin = wastePinService.inMemoryList.random();
    } else {
      wastePin = preloadPin;
    }
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Text("Below is photo view widget."),
            Text("This widget hvae update photo or add photo option"),
            AspectRatio(
                aspectRatio: 1.666,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: WastePhoto(wastePin: wastePin))),
          ],
        ),
      ),
    );
  }
}

typedef void PickedFileCallback(
    String photoFilePath, bool tookPhoto, DateTime photoTime);

// Screen to pick image from galerry and review photo (cropping pan zoom, optinally added later)
class WastePhoto extends StatefulWidget {
  final WastePin wastePin;
  final bool disableActions;
  final PickedFileCallback pickedFileCallback;

  final bool downloadAvailable;
  const WastePhoto(
      {Key key,
      this.wastePin,
      this.pickedFileCallback,
      this.downloadAvailable = false,
      this.disableActions = false})
      : super(key: key);

  @override
  _WastePhotoState createState() => _WastePhotoState();
}

class _WastePhotoState extends State<WastePhoto> {
  File _image;
  final picker = ImagePicker();
  DateTime photoTime;
  bool get isNetworkImage {
    return (_image == null && widget.wastePin?.remoteUrl != null);
  }

  bool get isLocalImage {
    return _image != null;
  }

  @override
  initState() {
    super.initState();

    if (widget.wastePin?.localFilePath != null) {
      _image = File(widget.wastePin.localFilePath);
    } else if (widget.wastePin?.remoteUrl != null) {
      // todo download option.
      _image = null;
    }

    Fimber.i("File: $_image");
  }

  Future getFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        extractExif(pickedFile.path);
        widget.pickedFileCallback(pickedFile.path, true, photoTime);
      });
    }
  }

  extractExif(String filePath) async {
    Map<String, IfdTag> data =
        await readExifFromBytes(await new File(filePath).readAsBytes());

    if (data == null || data.isEmpty) {
      Fimber.i("No EXIF information found\n");
      return;
    }

    data.keys.forEach((key) {
      Fimber.i(
          'Key: $key, type: ${data[key].tagType}, value: ${data[key]} ${data[key].printable}');
    });
    var dateUnformatted = data["Image DateTime"].printable;
    dateUnformatted = dateUnformatted.replaceFirst(":", "-");
    dateUnformatted = dateUnformatted.replaceFirst(":", "-");
    photoTime = DateTime.parse(dateUnformatted);
    if (data['GPS GPSLatitude'] != null && data['GPS GPSLongitude'] != null) {
      var signLatitude = (data['GPS GPSLatitudeRef']=='N')? 1 : -1;
      var signLongitude = (data['GPS GPSLongitudeRef']=='E')? 1: -1;
      // data['GPS GPSLatitude']
    }
    setState(() {});

    Fimber.i("Capture time: $photoTime - ${data["Image DateTime"].printable}");
    data.values.forEach((element) {
      Fimber.i(
          "${element.tag}/${element.tagType} ${element.values.toString()} - ${element.printable}");
    });
  }

  Future getFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);

        extractExif(pickedFile.path);
        widget.pickedFileCallback(pickedFile.path, false, photoTime);
      });
    }
  }

  Future downloadImage() async {
    // todo download image locally and update WastePin
  }
  removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Fimber.i(
        "File: $_image; isNetwork: $isNetworkImage; isLocal: $isLocalImage");
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: isNetworkImage
                ? Image.network(widget.wastePin.remoteUrl)
                : (!isLocalImage)
                    ? Text('No image selected.')
                    : (Image.file(_image)),
          ),
        ),
        Visibility(
          child: Positioned(
            top: 16,
            right: 16,
            child: FlatButton.icon(
              label: Text("Download locally"),
              onPressed: downloadImage,
              icon: Icon(Icons.file_download),
            ),
          ),
          visible: (isNetworkImage && widget.downloadAvailable),
        ),
        Visibility(
          visible: !widget.disableActions,
          child: Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: isLocalImage,
                  child: Container(
                    width: 56,
                    height: 56,
                    child: MaterialButton(
                      shape: CircleBorder(
                          side: BorderSide(width: 0, style: BorderStyle.none)),
                      child: Center(
                        child: Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).backgroundColor,
                          semanticLabel: "Remove Image",
                        ),
                      ),
                      color: MyCustomTheme.primaryColor,
                      onPressed: removeImage,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 56,
                  height: 56,
                  child: MaterialButton(
                    shape: CircleBorder(
                        side: BorderSide(width: 0, style: BorderStyle.none)),
                    child: Center(
                      child: Icon(
                        Icons.photo_library,
                        color: Theme.of(context).backgroundColor,
                        semanticLabel: 'Pick Image',
                      ),
                    ),
                    color: MyCustomTheme.primaryColor,
                    onPressed: getFromGallery,
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 56,
                  height: 56,
                  child: MaterialButton(
                    shape: CircleBorder(
                        side: BorderSide(width: 0, style: BorderStyle.none)),
                    child: Icon(
                      Icons.add_a_photo,
                      color: Theme.of(context).backgroundColor,
                      semanticLabel: 'Snap photo',
                    ),
                    color: MyCustomTheme.primaryColor,
                    onPressed: getFromCamera,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
