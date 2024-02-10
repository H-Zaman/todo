import 'package:flutter/material.dart';

abstract class AppTextStyle{
  static TextStyle get bold48 => TextStyle(
    fontSize: 44,
    height: 1.1,
    fontWeight: FontWeight.bold
  );

  static TextStyle get bold24 => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold
  );

  static TextStyle get medium24 => TextStyle(
    fontSize: 18,
  );

  static TextStyle get medium12 => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w200
  );

  static TextStyle get normal20 => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal
  );
}