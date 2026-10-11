import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/search/presentation/controllers/search/search_cubit.dart';
import 'package:konoz/features/search/presentation/ui/widgets/trending_search_section.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<SearchCubit>().searchNow(q);
    context.push('${Routes.home}/${Routes.search}/${Routes.searchResult}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: paddingHorizontal(16),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    CustomBackIcon(),
                    8.horizontalSpace,
                    Expanded(
                      child: AppTextFormField(
                        controller: _controller,
                        hint: LocaleKeys.general_search_hint.tr(),
                        maxLines: 1,
                        textInputAction: TextInputAction.search,
                        onChanged: (v) =>
                            context.read<SearchCubit>().onQueryChanged(v),
                        onFieldSubmitted: _submit,
                        prefixIcon: Padding(
                          padding: paddingAll(14),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedSearch01,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (p, c) =>
                    p.isTyping != c.isTyping ||
                    p.suggestions != c.suggestions ||
                    p.suggestionsLoading != c.suggestionsLoading,
                builder: (context, state) {
                  // مفيش كتابة: الـ Trending
                  if (!state.isTyping) return const TendingSearchSection();

                  // بيحمّل أول مرة
                  if (state.suggestionsLoading && state.suggestions.isEmpty) {
                    return SliverPadding(
                      padding: paddingVertical(32),
                      sliver: const SliverToBoxAdapter(child: AppLoading()),
                    );
                  }

                  // مفيش اقتراحات
                  if (state.suggestions.isEmpty) {
                    return SliverPadding(
                      padding: paddingVertical(24),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            LocaleKeys.general_search_no_results.tr(),
                            style: AppTextStyles.text12Regular,
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: paddingVertical(16),
                    sliver: SliverList.separated(
                      itemCount: state.suggestions.length,
                      separatorBuilder: (_, _) => 12.verticalSpace,
                      itemBuilder: (context, index) {
                        final term = state.suggestions[index];
                        return InkWell(
                          onTap: () {
                            _controller.text = term;
                            _controller.selection = TextSelection.collapsed(
                              offset: term.length,
                            );
                            _submit(term);
                          },
                          child: Padding(
                            padding: paddingVertical(4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_outward_outlined,
                                  color: AppColors.white,
                                  size: 15.sp,
                                ),
                                6.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    term,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.text12Regular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
