import 'dart:async';
import 'dart:ui';

import 'package:animate_do/animate_do.dart' hide SpinState;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/require_login.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/bouncing_text.dart';
import 'package:konoz/features/spin/presentation/controllers/spin/spin_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _messages = [LocaleKeys.spin_event_banner.tr()];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // BlocBuilder بيرجّع sliver مباشرة (من غير SliverToBoxAdapter)
    return BlocBuilder<SpinCubit, SpinState>(
      builder: (context, state) {
        // يظهر بس لو العجلة مفعّلة واليوزر لسه عنده لفّة
        if (state.isInitial ||
            state.isLoading ||
            !state.isEnabled ||
            !state.hasSpin) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        final isArabic = context.locale.languageCode == 'ar';

        return SliverPersistentHeader(
          // يختفي مع scroll لتحت، ويظهر فورًا أول ما تطلع لفوق (من غير ما توصل للأول)
          pinned: false,
          floating: true,
          delegate: _PinnedHeaderDelegate(
            height: 84.h,
            child: Center(
              child: Padding(
                padding: paddingSymmetric(16, 8),
                child: KeyedSubtree(
                  key: ValueKey(_currentIndex),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    from: 20,
                    curve: Curves.easeOutCubic,
                    child: ClipRRect(
                      borderRadius: AppRadius.br12,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.br12,
                            // تدرج شفاف عشان شكل الزجاج
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.neutral500.withValues(alpha: 0.15),
                                AppColors.neutral500.withValues(alpha: 0.09),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.neutral500.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                // ضيف: يطلب لوجين الأول، مسجّل: يدخل على الـ spin
                                if (!await requireLogin(context)) return;
                                if (!context.mounted) return;
                                context.push(Routes.spin);
                              },
                              child: Padding(
                                padding: paddingSymmetric(12, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppImage.asset(
                                      ImagesPaths.luckyWheel,
                                      width: 32,
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: isArabic
                                            ? Text(
                                                _messages[_currentIndex],
                                                style: AppTextStyles.text14Bold
                                                    .copyWith(
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                              )
                                            : BouncingText(
                                                _messages[_currentIndex],
                                                style: AppTextStyles.text14Bold
                                                    .copyWith(
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                                highlightColor:
                                                    AppColors.primary,
                                                interval: const Duration(
                                                  seconds: 6,
                                                ),
                                                bounceHeight: 3,
                                              ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14.sp,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// header بارتفاع ثابت (min = max) عشان يفضل متثبت فوق
class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  // الـ child بيتغير (لغة / index)، فلازم يعيد البناء
  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) => true;
}
