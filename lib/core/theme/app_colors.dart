import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const primary = Color(0xffca6702);
  //static const primary500 = Color(0xff198C8C);

  // Base
  static const black = Color(0xff000000);
  static const white = Color(0xffffffff);

  // Background
  static const background = Color(0xffffffff);

  // Neutral
  static const neutral500 = Color(0xff94A3B8);
  static const neutral600 = Color(0xff64748B);

  // Semantic — Success
  static const success800 = Color(0xff2CAA81);
  static const success100 = Color(0xffF1FCFA);

  // Semantic — Error
  static const error800 = Color.fromARGB(255, 65, 17, 17);
  static const error700 = Color(0xffEB1717);
  static const error100 = Color(0xffFFF1F1);

  // Semantic — Warning
  static const warning900 = Color(0xffDF8806);
}
