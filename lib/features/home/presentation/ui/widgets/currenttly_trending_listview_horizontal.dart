import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class CurrenttlyTrendingListviewHorizontal extends StatelessWidget {
  const CurrenttlyTrendingListviewHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: IntrinsicHeight(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: paddingHorizontal(16),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          separatorBuilder: (context, index) => 8.horizontalSpace,
          itemBuilder: (context, index) => Container(
            width: 120.w,
            decoration: BoxDecoration(
              borderRadius: AppRadius.br16,
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AppImage.cachedNetwork(
                      height: 125,
                      width: 125,
                      borderRadius: AppRadius.br16,
                      "https://i.pinimg.com/736x/33/fb/d3/33fbd31fdfa238dc013399ca4aa6aaac.jpg",
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: CircleAvatar(
                        backgroundColor: AppColors.error700,
                        radius: 12.r,
                        child: Text("35%", style: AppTextStyles.text10Bold),
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,
                Padding(
                  padding: paddingHorizontal(8),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.sp),
                      2.horizontalSpace,
                      Text("4.9 (150)", style: AppTextStyles.text10Regular),
                    ],
                  ),
                ),
                2.verticalSpace,
                Padding(
                  padding: paddingHorizontal(8),
                  child: Text("Burberry Her", style: AppTextStyles.text14Bold),
                ),
                2.verticalSpace,
                Padding(
                  padding: paddingHorizontal(8),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "350 L.E",
                          style: AppTextStyles.text12Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      4.horizontalSpace,
                      Flexible(
                        child: Text(
                          "500",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.text12Regular.copyWith(
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.primary,
                            decorationThickness: 1.8,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
