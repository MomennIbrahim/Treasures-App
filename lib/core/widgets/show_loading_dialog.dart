import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/widgets/app_loading.dart';

bool _isLoadingDialogShown = false;

/// يعرض dialog تحميل ويمنع الضغط خارجه والرجوع بالـ back
void showLoadingDialog(BuildContext context) {
  if (_isLoadingDialogShown) return;
  _isLoadingDialogShown = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => PopScope(
      canPop: false,
      child: Center(
        child: SizedBox(width: 32.w, height: 32.h, child: AppLoading()),
      ),
    ),
  ).then((_) => _isLoadingDialogShown = false);
}

/// يقفل الـ dialog لو مفتوح
void hideLoadingDialog(BuildContext context) {
  if (!_isLoadingDialogShown) return;
  Navigator.of(context, rootNavigator: true).pop();
}
