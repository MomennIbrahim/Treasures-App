import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

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
    final isAr = context.locale.languageCode == "ar";
    const radius = Radius.circular(12);

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
              width: 135,
              fit: BoxFit.cover,
              borderRadius: AppRadius.only(
                topLeft: isAr ? Radius.zero : radius,
                bottomLeft: isAr ? Radius.zero : radius,
                topRight: isAr ? radius : Radius.zero,
                bottomRight: isAr ? radius : Radius.zero,
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
                      '${package.price} EGP',
                      style: AppTextStyles.text14Bold.copyWith(
                        color: Colors.amber,
                      ),
                    ),

                    6.verticalSpace,

                    Text(
                      '$productsCount ${LocaleKeys.home_products_included.tr()}',
                      style: AppTextStyles.text10Bold.copyWith(
                        color: Colors.amber,
                      ),
                    ),
                    6.verticalSpace,

                    // الأصناف جنب بعض، ولما السطر يتملي بتنزل سطر جديد،
                    // فطول الكارد مبيكبرش لو الباكدج فيها أصناف كتير
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: package.items
                          .map(
                            (item) => Container(
                              padding: paddingSymmetric(6, 2),
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: AppRadius.br8,
                              ),
                              child: Text(
                                '${item.quantity}× ${item.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.text10Bold,
                              ),
                            ),
                          )
                          .toList(),
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
