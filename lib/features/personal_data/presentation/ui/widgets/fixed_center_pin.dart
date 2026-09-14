import 'package:flutter/material.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/app_image.dart';

/// الدبوس الثابت في نص الشاشة، فوق الماب مباشرة، مش جزء من الـ GoogleMap
/// نفسه (مش Marker) عشان يفضل ثابت بصريًا وقت ما المستخدم بيسحب الخريطة.
class FixedCenterPin extends StatelessWidget {
  const FixedCenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Padding(
          // بنرفعه لفوق بمقدار نص ارتفاعه عشان طرف الدبوس (مش نص الأيقونة)
          // هو اللي يمثل النقطة الفعلية على الخريطة.
          padding: paddingOnly(bottom: 16),
          child: AppImage.asset(ImagesPaths.pin, width: 48),
        ),
      ),
    );
  }
}
