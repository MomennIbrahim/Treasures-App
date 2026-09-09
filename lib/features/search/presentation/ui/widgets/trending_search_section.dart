import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/search/presentation/ui/widgets/suggestion_chip.dart';

class TendingSearchSection extends StatelessWidget {
  const TendingSearchSection({super.key});
  // Demo data - هتتشال لما نربطها بالـ API
  static const List<String> _suggestions = [
    "Dior Sauvage",
    "Oud",
    "Chanel No. 5",
    "Tom Ford",
    "Musk",
    "Versace Eros",
    "Bakhoor",
  ];
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingOnly(top: 20, bottom: 12),
            child: Text("Trending Searches", style: AppTextStyles.text14Bold),
          ),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _suggestions.map((suggestion) {
              return SuggestionChip(
                label: suggestion,
                onTap: () {
                  context.push(Routes.productDetails);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
