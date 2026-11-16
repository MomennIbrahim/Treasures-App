import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderDetailsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const OrderDetailsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          12.verticalSpace,
          OutlinedButton(
            onPressed: onRetry,
            child: Text(LocaleKeys.general_retry.tr()),
          ),
        ],
      ),
    ),
  );
}
