import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Camera screen to take a photo and assing location bearing sensor data for the Wastepin
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Placeholder(),
            ),
            Positioned(
              top: 16,
              child: Text("Make a photo"),
            ),
            Positioned(
              child: Container(
                child: Icon(
                  Icons.photo_camera,
                  size: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
