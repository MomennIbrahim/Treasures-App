import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 2,
      separatorBuilder: (context, index) => 15.verticalSpace,
      itemBuilder: (context, index) => _buildCartItemWidget(index, context),
    );
  }

  Container _buildCartItemWidget(int index, BuildContext context) {
    return Container(
      padding: paddingAll(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: AppRadius.br12,
      ),
      child: Row(
        children: [
          AppImage.cachedNetwork(
            'https://i.pinimg.com/736x/cd/78/f8/cd78f82c6f052162af45b1b2fead67fc.jpg',
            width: 100,
            borderRadius: AppRadius.br8,
          ),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Burberry Her 50 ml', style: AppTextStyles.text12Bold),
                6.verticalSpace,
                Text(
                  'A beautiful feminine fragrance with a sweet and elegant character.',
                  style: AppTextStyles.text12Regular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '2500 L.E',
                        style: AppTextStyles.text16Bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    6.horizontalSpace,
                    Container(
                      padding: paddingAll(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: AppRadius.br24,
                        border: Border.all(
                          color: AppColors.neutral500.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCustomCartActionButton(onTap: () {}),
                          7.horizontalSpace,
                          Text("1", style: AppTextStyles.text14Regular),
                          7.horizontalSpace,
                          _buildCustomCartActionButton(
                            onTap: () {},
                            icon: Icons.remove,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildCustomCartActionButton({
    void Function()? onTap,
    IconData icon = Icons.add,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: paddingAll(4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18.sp),
      ),
    );
  }
}
