import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();

  static TextStyle bold([double? fontSize]) => TextStyle(
        fontFamily: 'Poppins-Bold',
        fontSize: fontSize ?? 24,
        color: Colors.black,
      );
  static TextStyle normal([double? fontSize]) => TextStyle(
        fontFamily: 'Poppins-Regular',
        fontSize: fontSize ?? 16,
        color: Colors.black,
      );
  static TextStyle italic([double? fontSize]) => TextStyle(
        fontFamily: 'Poppins-Italic',
        fontSize: fontSize ?? 14,
        color: Colors.black,
      );
}
