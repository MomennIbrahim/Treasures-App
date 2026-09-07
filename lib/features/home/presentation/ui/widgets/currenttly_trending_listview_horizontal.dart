import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currently_trending_item.dart';

class CurrenttlyTrendingListviewHorizontal extends StatelessWidget {
  const CurrenttlyTrendingListviewHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 177.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: paddingHorizontal(16),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (context, index) => 8.horizontalSpace,
        itemBuilder: (context, index) => CurrentlyTrendingItem(),
      ),
    );
  }
}
