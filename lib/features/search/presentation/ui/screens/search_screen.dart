import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/search/presentation/ui/widgets/trending_search_section.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: paddingAll(16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    CustomBackIcon(),
                    8.horizontalSpace,
                    Expanded(
                      child: AppTextFormField(
                        hint: "Search for perfumery or fragrances...",
                        maxLines: 1,
                        prefixIcon: Padding(
                          padding: paddingAll(14),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedSearch01,
                            color: AppColors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              TendingSearchSection(),

              SliverPadding(
                padding: paddingVertical(16),
                sliver: SliverList.separated(
                  itemCount: 6,
                  separatorBuilder: (context, index) => 12.verticalSpace,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Icon(
                          Icons.arrow_outward_outlined,
                          color: AppColors.white,
                          size: 15.sp,
                        ),
                        6.horizontalSpace,
                        Text(
                          "Blue Dove by Dolce & Gabbana",
                          style: AppTextStyles.text12Regular,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
