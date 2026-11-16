import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';

class PackageItem extends StatelessWidget {
  final PackageItemModel package;
  final bool isLoading;

  const PackageItem({
    super.key,
    required this.package,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final productsCount = package.items.length;

    return GestureDetector(
      onTap: () => context.push(
        '${Routes.home}/${Routes.packageDetails}',
        extra: package.id,
      ),
      child: Container(
        margin: paddingHorizontal(16),
        decoration: BoxDecoration(
          borderRadius: AppRadius.br12,
          border: Border.all(color: colorScheme.onSurfaceVariant.withAlpha(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage.cachedNetwork(
              package.image,
              height: 160,
              width: 150,
              borderRadius: AppRadius.only(
                topLeft: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
              ),
            ),

            Expanded(
              child: Padding(
                padding: paddingSymmetric(10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.text12Bold,
                    ),

                    8.verticalSpace,

                    Text(
                      '${package.price} L.E',
                      style: AppTextStyles.text14Bold.copyWith(
                        color: Colors.amber,
                      ),
                    ),

                    6.verticalSpace,

                    Text(
                      '$productsCount Products Included',
                      style: AppTextStyles.text10Bold.copyWith(
                        color: Colors.amber,
                      ),
                    ),

                    6.verticalSpace,

                    ...package.items.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          '${item.quantity} × ${item.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.text10Bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
