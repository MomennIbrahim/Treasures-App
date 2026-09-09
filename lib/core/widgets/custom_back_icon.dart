import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/theme/app_colors.dart';

class CustomBackIcon extends StatelessWidget {
  const CustomBackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      child: Icon(Icons.arrow_back, color: AppColors.white),
    );
  }
}
