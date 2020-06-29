import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wastepin/routes.dart';
import 'package:wastepin/theme/custom_theme.dart';
import 'package:wastepin/utils/app_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  Animation _curvedAnimation;
  AnimationController _controller;
  double _scale = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _controller,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _animation = Tween(begin: 175.0, end: 200.0).animate(_curvedAnimation)
      ..addListener(() {
        setState(() {
          _scale = _animation.value;
        });
      });
    Future.delayed(Duration(milliseconds: 2000), () {
      _controller.reset();

      AppUtils.NAVIGATOR_UTILS.navigatorPopAndPushNamed(context, MyRoutes.ONBOARDING_ROOT);

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox(
        width: _scale,
        height: _scale,
        child: WebsafeSvg.asset("assets/logo.svg"),

      ),
    );
  }

}

//class SplashScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: [
//          WebsafeSvg.asset("assets/logo.svg"),
//          const SizedBox(height: 20),
//          Center(
//            child: CircularProgressIndicator(
//              strokeWidth: 1,
//              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
