import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trashtag/data/wastepin.dart';

import '../debug-main.dart';

class WastePhotoScreenTest extends StatelessWidget {
  final bool isNew;
  final WastePin preloadPin;

  WastePhotoScreenTest({this.isNew = true, this.preloadPin});

  @override
  Widget build(BuildContext context) {
    WastePin wastePin;
    if (!isNew) {
      wastePin = wastePinService.fetch().random();
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

// Screen to pick image from galerry and review photo (cropping pan zoom, optinally added later)
class WastePhoto extends StatefulWidget {
  final WastePin wastePin;
  final bool disableActions;

  final bool downloadAvailable;
  const WastePhoto(
      {Key key,
      this.wastePin,
      this.downloadAvailable = false,
      this.disableActions = false})
      : super(key: key);

  @override
  _WastePhotoState createState() => _WastePhotoState();
}

class _WastePhotoState extends State<WastePhoto> {
  File _image;
  final picker = ImagePicker();

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
      });
    }
  }

  Future getFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
                          side: BorderSide(
                              width: 0,
                              color: Colors.red,
                              style: BorderStyle.solid)),
                      child: Center(
                        child: Icon(
                          Icons.delete_forever,
                          semanticLabel: "Remove Image",
                        ),
                      ),
                      color: Colors.yellow,
                      onPressed: getFromGallery,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 56,
                  height: 56,
                  child: MaterialButton(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 0,
                            color: Colors.red,
                            style: BorderStyle.solid)),
                    child: Center(
                      child: Icon(
                        Icons.photo_library,
                        semanticLabel: 'Pick Image',
                      ),
                    ),
                    color: Colors.yellow,
                    onPressed: getFromGallery,
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 56,
                  height: 56,
                  child: MaterialButton(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 0,
                            color: Colors.red,
                            style: BorderStyle.solid)),
                    child: Icon(
                      Icons.add_a_photo,
                      semanticLabel: 'Snap photo',
                    ),
                    color: Colors.yellow,
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
