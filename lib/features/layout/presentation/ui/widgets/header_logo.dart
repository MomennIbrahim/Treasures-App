import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({super.key});

  static const String logoPath = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAll(8),
      child: Image.asset(logoPath, width: 55, fit: BoxFit.contain),
    );
  }
}
