import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class Prize {
  final String? amount;
  final String? labelKey;
  final Color color;
  const Prize({this.amount, this.labelKey, required this.color});

  String get label => labelKey?.tr() ?? amount!;
  bool get isTryAgain => labelKey == LocaleKeys.spin_free_spin;
}

const List<Prize> prizes = [
  Prize(labelKey: LocaleKeys.spin_better_luck, color: Color(0xFFEFBF04)),
  Prize(
    amount: 'Buy 1 [100 ml] Get 1 [30 ml]',
    color: AppColors.darkBackground,
  ),
  Prize(labelKey: "50% OFF", color: Color(0xFFEFBF04)),
  Prize(amount: '35% OFF', color: AppColors.darkBackground),
  Prize(amount: 'Buy 2 [100 ml] Get 1 [50 ml]', color: Color(0xFFEFBF04)),
  Prize(labelKey: LocaleKeys.spin_free_spin, color: AppColors.darkBackground),
  Prize(amount: 'Buy 2 [100 ml] Get 1 [50 ml]', color: Color(0xFFEFBF04)),
  Prize(labelKey: LocaleKeys.spin_free_spin, color: AppColors.darkBackground),
];
