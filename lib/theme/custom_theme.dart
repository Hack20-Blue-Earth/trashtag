import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';





final ThemeData myCustomTheme = new ThemeData(
  primaryColor: CustomTheme.colorPrimary,
  backgroundColor: CustomTheme.colorWhite,

  scaffoldBackgroundColor: CustomTheme.colorWhite,
  cursorColor: CustomTheme.colorBotton,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: CustomTheme.colorGradientTop
  ),

  accentColor: CustomTheme.colorGradientBottom,
);



class CustomTheme {

  //Theme colors from figma file
  static const Color backgroundColor = Color(0xffF2F6FF);
  static const Color primaryColor = Color(0xff8352FD);
  static const Color neutralDarkColor = Color(0xff1A2151); //Used in text



  static const Color colorPrimary = Color(0xFF25282B);
  static const Color colorWhite = Colors.white;
  static const Color colorGreyText = Color(0xFF52575C);
  static const Color colorGreyBackground = Color(0xFFE8E8E8);
  static const Color colorGradientTop =  Color(0xFFaa91be);
  static const Color colorBotton =  Color(0xFFac7c94);
  static const Color colorGradientBottom =  Color(0xFFf7d8c7);


  static const Map<int, Color> GREY = const <int, Color>{
    400: const Color(0xFFbdbdbd),
    500: const Color(0xFF9e9e9e),
    600: const Color(0xFF757575),
    700: const Color(0xFF616161),
    800: const Color(0xFF424242),
    900: const Color(0xFF212121),
  };


//----------------------------------------------------------------------Common Text Style----------------------------------------------------------------------------------------------------------------

//  static final TextStyle commonHeadTextStyle = TextStyle(color: colorGreyText, fontSize: FONT_SIZE_20, fontFamily: ROBOTO, fontWeight: ROBOTO_BOLD_WEIGHT);
//  static final TextStyle commonTitleTextStyle = TextStyle(color: colorGreyText, fontSize: FONT_SIZE_18, fontFamily: ROBOTO, fontWeight: ROBOTO_BOLD_WEIGHT);
//  static final TextStyle commonSubTitleTextStyle = TextStyle(color: colorGreyText, fontSize: FONT_SIZE_16, fontFamily: ROBOTO, fontWeight: ROBOTO_REGULAR_WEIGHT);

//-------------------------------------------------------------------------Title-------------------------------------------------------------------------------------------------------------



}
