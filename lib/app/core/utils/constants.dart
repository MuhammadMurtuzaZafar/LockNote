import 'package:flutter/material.dart';

class KColor {
  KColor._();

  static const kPrimaryColor = Color(0xFF002342);
  static const kPrimaryLightColor = Color(0xff0c3178);
  static const kPrimaryRedColor = Color(0xffd92727);
  static const Color grey = Color(0xFF7A7A7A);
  static const Color disableColor = Color(0xFF868686);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFEEEBEB);
  static const Color green = Color(0xFF246D03);
  static const Color scaffold_bg  = Color(0xff3f3f44);
  static const Color card_bg  = Color(0xFF4B4848);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);

  /// 1 Theme Light
  static const textColorTheme1 = Color(0xFFFFFFFF);
  static const backgourndColorTheme1 = Color(0xFFFFFFFF);

  /// 2 Theme Dark
  static const textColorTheme2 = Color(0xFF01132D);

  /// 3 Theme Light
  static const textColorTheme3 = Color  (0xFF192F4B);

  ///Box Decoration
  static BoxDecoration kCardDecorationImage = BoxDecoration(
    borderRadius: BorderRadius.circular(12.0),
  );

  static BoxDecoration kCardWhiteDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(12.0),
  );
}

class ConstantValues {
 static const String title = 'Notes App';
 static const String fingerPrintErrorMsg = 'Your Device Not Support Finger Print Method';
}
class DbConstant{
  static const databaseVersion = 1;
  static const String dbName = 'notesApp.db';
  static const String tableName = 'notes';
}
class SnackBarHelper {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
class Ksize
{
  double? _width;
  double? _height;

  double get width => _width??0;

  set width(double value) {
    _width = value;
  }

  double get height => _height??0;

  set height(double value) {
    _height = value;
  }
}