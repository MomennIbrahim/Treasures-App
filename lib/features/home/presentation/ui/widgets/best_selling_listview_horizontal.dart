import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_item.dart';

class BestSellingListviewHorizontal extends StatelessWidget {
  const BestSellingListviewHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: paddingHorizontal(16),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) => BestSellingItem(),
      ),
    );
  }
}
