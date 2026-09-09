import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: paddingSymmetric(16, 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: AppRadius.br12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                AppImage.cachedNetwork(
                  "https://i.pinimg.com/736x/eb/76/a4/eb76a46ab920d056b02d203ca95e9a22.jpg",
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                  borderRadius: AppRadius.br8,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, ${"Momen"}', style: AppTextStyles.text16Bold),
                      Text("Momen@gmail.com", style: AppTextStyles.text12Bold),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
