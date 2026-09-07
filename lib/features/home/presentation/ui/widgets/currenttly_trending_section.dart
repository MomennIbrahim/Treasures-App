import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currenttly_trending_listview_horizontal.dart';

class CurrenttlyTrendingSection extends StatelessWidget {
  const CurrenttlyTrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingOnly(left: 16, right: 16, top: 16),
            child: Text("Currently Trending", style: AppTextStyles.text14Bold),
          ),
          10.verticalSpace,
          CurrenttlyTrendingListviewHorizontal(),
        ],
      ),
    );
  }
}
