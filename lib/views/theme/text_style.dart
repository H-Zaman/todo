import 'package:flutter/material.dart';

abstract class AppTextStyle{
  static TextStyle get bold48 => TextStyle(
    fontSize: 44,
    height: 1.1,
    fontWeight: FontWeight.bold
  );

  static TextStyle get medium24 => TextStyle(
    fontSize: 18,
  );
}