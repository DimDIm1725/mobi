import 'package:flutter/material.dart';

class MobiTheme {
  MobiTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color lightGreen = Color(0xFFd2f8d2);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color darkBlue = Color(0xFF1A237E);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color selectedTileColor = Color(0xAA607D8B);
  static const Color red = Color.fromARGB(255, 253, 68, 98);
  static const Color yellow = Color.fromARGB(255, 253, 214, 52);
  static const Color green = Color.fromARGB(255, 111, 238, 175);
  static const Color purple = Color.fromARGB(255, 114, 113, 252);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color negativeColor = Colors.orangeAccent;

  static const Color colorGrey = Color.fromARGB(255, 209, 210, 205);
  static const Color colorPrimary = Color(0xff26272D);
  static const Color colorBackground = Color(0xff2D2D33);
  static const Color colorCompanion = Color(0xff209F85);
  static const Color borderColor = Color(0xff454751);
  static const Color colorIcon = Color(0xff209F85);
  static const List<Color> colorsGradient = [
    Color.fromARGB(80, 0x26, 0x27, 0x2d),
    colorPrimary
  ];

  static const Color colorDrawer = Color.fromARGB(255, 22, 23, 27);

  static const TextStyle text16BoldBlack = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontSize: 16,
  );

  static const TextStyle text20BoldWhite = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static const TextStyle text16BoldWhite = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 16,
  );

  static const TextStyle text16Black = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText1: body2,
    bodyText2: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );

  static const MaterialColor primarySwatch = const MaterialColor(
    0xFF000000,
    const <int, Color>{
      50: const Color(0xff209F85),
      100: const Color(0xff209F85),
      200: const Color(0xff209F85),
      300: const Color(0xff209F85),
      400: const Color(0xff209F85),
      500: const Color(0xff209F85),
      600: const Color(0xff209F85),
      700: const Color(0xff209F85),
      800: const Color(0xff209F85),
      900: const Color(0xff209F85),
    },
  );
}
