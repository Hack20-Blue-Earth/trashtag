import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trashtag/data/wastepin.dart';

import '../debug-main.dart';

class WastePhotoScreenTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    child: WastePhotoPicker(
                        wastePin: wastePinService.fetch().first))),
          ],
        ),
      ),
    );
  }
}

// Screen to pick image from galerry and review photo (cropping pan zoom, optinally added later)
class WastePhotoPicker extends StatefulWidget {
  final WastePin wastePin;

  const WastePhotoPicker({Key key, this.wastePin}) : super(key: key);

  @override
  _WastePhotoPickerState createState() => _WastePhotoPickerState();
}

class _WastePhotoPickerState extends State<WastePhotoPicker> {
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
        isNetworkImage
            ? Positioned(
                top: 16,
                right: 16,
                child: FlatButton.icon(
                  label: Text("Download locally"),
                  onPressed: downloadImage,
                  icon: Icon(Icons.file_download),
                ),
              )
            : SizedBox(width: 0, height: 0),
        Positioned(
          bottom: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (!isLocalImage)
                  ? SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : FloatingActionButton(
                      onPressed: removeImage,
                      heroTag: "FAB-remove",
                      tooltip: 'Clear image',
                      child: Icon(Icons.delete_forever),
                    ),
              SizedBox(width: 16),
              FloatingActionButton(
                heroTag: "FAB-pick",
                onPressed: getFromGallery,
                tooltip: 'Pick Image',
                child: Icon(Icons.photo_library),
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                heroTag: "FAB-fcamera",
                onPressed: getFromCamera,
                tooltip: 'Snap Photo',
                child: Icon(Icons.add_a_photo),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
