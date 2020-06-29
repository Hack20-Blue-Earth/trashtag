import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wastepin/theme/custom_theme.dart';
import 'package:websafe_svg/websafe_svg.dart';


class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WebsafeSvg.asset("assets/logo.svg"),
          const SizedBox(height: 20),
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
