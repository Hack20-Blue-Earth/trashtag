import 'package:flutter/material.dart';
import 'package:wastepin/routes.dart';
import 'package:wastepin/theme/custom_theme.dart';
import 'package:wastepin/utils/app_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyCustomTheme.backgroundColor,
      body: Stack(
        children: [
          PageView(
            onPageChanged: (int index) => setState(() => currentPage = index),
            children: [
              PageViewItem(
                pageNumber: "1",
                stepDescription: "Click a picture",
              ),
              PageViewItem(
                pageNumber: "2",
                stepDescription: "Enter the location",
                paddingTop: 15,
              ),
              PageViewItem(
                pageNumber: "3",
                stepDescription: "Done! We will inform authorities",
              ),
            ],
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                  child: WebsafeSvg.asset("assets/logo.svg"),
                ),
                SizedBox(
                  width: 240,
                  child: Text(
                    "Helping people clean their surrounding",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Indicator(isSelected: currentPage == 0),
                      Indicator(isSelected: currentPage == 1),
                      Indicator(isSelected: currentPage == 2, isLast: true),
                    ],
                  ),
                ),
                StartButton(currentPage: currentPage),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key key,
    this.isSelected,
    this.isLast = false,
  }) : super(key: key);

  final bool isSelected;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSelected ? 12 : 8,
      width: isSelected ? 12 : 6,
      margin: EdgeInsets.only(right: isLast ? 0 : 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyCustomTheme.neutralDarkColor,
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key key, this.currentPage}) : super(key: key);

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: currentPage == 2
            ? FlatButton(
                child: Text(
                  "Start cleaning surrounding",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                color: MyCustomTheme.primaryColor,
                textColor: MyCustomTheme.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {

                  AppUtils.NAVIGATOR_UTILS.navigatorPopAndPushNamed(context, MyRoutes.ISSUE_ROOT);

                },
              )
            : null,
      ),
    );
  }
}

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    Key key,
    this.pageNumber,
    this.stepDescription,
    this.paddingTop = 0,
  }) : super(key: key);

  final String pageNumber;
  final String stepDescription;
  final double paddingTop;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: 60 + paddingTop, bottom: 60 - paddingTop),
          child: WebsafeSvg.asset(
            "assets/onboarding_$pageNumber.svg",
            height: 280,
          ),
        ),
        Text(
          "Step $pageNumber \n$stepDescription",
          style: TextStyle(
            fontSize: 15,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
