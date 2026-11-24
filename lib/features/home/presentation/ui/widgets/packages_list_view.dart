import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/features/home/presentation/ui/widgets/package_item.dart';

class PackagesListView extends StatelessWidget {
  final List<PackageItemModel> packages;
  final bool isLoading;

  /// loading / إعادة في آخر الليست (null = مفيش)
  final Widget? footer;

  const PackagesListView({
    super.key,
    required this.packages,
    required this.isLoading,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final showFooter = !isLoading && footer != null;

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length + (showFooter ? 1 : 0),
      separatorBuilder: (context, index) => 10.verticalSpace,
      itemBuilder: (context, index) {
        if (index >= packages.length) return footer!;
        return PackageItem(package: packages[index], isLoading: isLoading);
      },
    );
  }
}