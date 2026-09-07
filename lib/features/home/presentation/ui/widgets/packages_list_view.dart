import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/features/home/presentation/ui/widgets/package_item.dart';

class PackagesListView extends StatelessWidget {
  const PackagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => 10.verticalSpace,
      itemBuilder: (context, index) {
        return PackageItem();
      },
    );
  }
}
