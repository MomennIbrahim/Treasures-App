import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/search/presentation/controllers/search/search_cubit.dart';
import 'package:konoz/features/search/presentation/ui/widgets/suggestion_chip.dart';

class TendingSearchSection extends StatelessWidget {
  const TendingSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocSelector<SearchCubit, SearchState, List<String>>(
        selector: (s) => s.trending,
        builder: (context, trending) {
          if (trending.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingOnly(top: 20, bottom: 12),
                child: Text(
                  "Trending Searches",
                  style: AppTextStyles.text14Bold,
                ),
              ),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: trending.map((term) {
                  return SuggestionChip(
                    label: term,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.read<SearchCubit>().searchNow(term);
                      context.push(
                        '${Routes.home}/${Routes.search}/${Routes.searchResult}',
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}