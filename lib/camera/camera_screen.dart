import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
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
