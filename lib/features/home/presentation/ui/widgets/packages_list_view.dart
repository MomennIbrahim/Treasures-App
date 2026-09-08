import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/features/home/data/demo/demo_packages_data.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/features/home/presentation/ui/widgets/package_item.dart';

class PackagesListView extends StatelessWidget {
  final List<PackageItemModel> packages;
  final bool isLoading;

  const PackagesListView({
    super.key,
    required this.packages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final displayPackages = isLoading
        ? DemoPackagesData.demo.packages
        : packages;

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayPackages.length,
      separatorBuilder: (context, index) => 10.verticalSpace,
      itemBuilder: (context, index) {
        return PackageItem(
          package: displayPackages[index],
          isLoading: isLoading,
        );
      },
    );
  }
}
