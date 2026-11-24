import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// العنصر الزيادة في آخر أي ليست متقسّمة: loading للصفحة التالية،
/// أو زرار إعادة لو فشلت. أفقي (جنب آخر عنصر) أو رأسي (تحته).
class LoadMoreFooter extends StatelessWidget {
  final Axis axis;
  final bool isLoading;
  final VoidCallback onRetry;

  const LoadMoreFooter({
    super.key,
    required this.isLoading,
    required this.onRetry,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final horizontal = axis == Axis.horizontal;

    final Widget content = isLoading
        ? SizedBox(width: 20.w, height: 20.w, child: const AppLoading())
        : horizontal
        ? IconButton(onPressed: onRetry, icon: const Icon(Icons.refresh))
        : TextButton(
            onPressed: onRetry,
            child: Text(LocaleKeys.general_retry.tr()),
          );

    if (horizontal) {
      return SizedBox(
        width: 56.w,
        child: Center(child: content),
      );
    }
    return Padding(
      padding: paddingSymmetric(0, 12),
      child: Center(child: content),
    );
  }
}
