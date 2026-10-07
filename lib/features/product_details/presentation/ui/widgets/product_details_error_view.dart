import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// بتظهر لما تحميل المنتج يفشل أو الـ product يرجع null.
/// فيها رسالة خطأ + زرار رجوع + Retry.
class ProductDetailsErrorView extends StatelessWidget {
  const ProductDetailsErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // لو اتفتحت الصفحة مباشرة من غير stack نرجع للهوم
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: paddingAll(8),
              child: IconButton(
                onPressed: () => _back(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: paddingHorizontal(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 56.sp,
                      color: colorScheme.error,
                    ),
                    16.verticalSpace,
                    Text(
                      LocaleKeys.errors_errors_unexpected.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.text14Regular,
                    ),
                    24.verticalSpace,
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text('general.retry'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}