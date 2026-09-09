import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingAll(16),
      sliver: SliverList.separated(
        itemCount: 2,
        separatorBuilder: (context, index) => 12.verticalSpace,
        itemBuilder: (context, index) => _buildOrderItem(),
      ),
    );
  }

  Container _buildOrderItem() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: AppRadius.br8,
      ),
      child: Row(
        children: [
          AppImage.cachedNetwork(
            borderRadius: AppRadius.only(
              topLeft: const Radius.circular(8),
              bottomLeft: const Radius.circular(8),
            ),
            "https://i.pinimg.com/736x/ef/2f/76/ef2f767715a8c352f92e680c7e51013d.jpg",
            width: 100,
            height: 110,
          ),

          Padding(
            padding: paddingHorizontal(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Versace Eros", style: AppTextStyles.text14Bold),
                Text(
                  "Order has been placed",
                  style: AppTextStyles.text12Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
