import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class CurrentlyTrendingItem extends StatelessWidget {
  const CurrentlyTrendingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppImage.cachedNetwork(
          height: 90,
          borderRadius: AppRadius.br8,
          "https://i.pinimg.com/736x/33/fb/d3/33fbd31fdfa238dc013399ca4aa6aaac.jpg",
        ),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 14.sp),
            2.horizontalSpace,
            Text("4.9 (150)", style: AppTextStyles.text10Regular),
          ],
        ),
        Text("Burberry Her", style: AppTextStyles.text12Bold),
      ],
    );
  }
}
