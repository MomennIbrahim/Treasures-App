import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';

/// كارت منتج صغير جوه الباكدج، بيفتح تفاصيل المنتج.
class PackageProductCard extends StatelessWidget {
  final PackageProductModel product;

  const PackageProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${Routes.home}/${Routes.productDetails}',
        // لازم extra، الراوت بيقراه (من غيره هيكرّاش)
        //  extra: ProductDetailsArgs(id: product.id, image: product.image),
      ),
      child: SizedBox(
        width: 110.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage.cachedNetwork(
              product.image,
              height: 110,
              width: 110.w,
              borderRadius: AppRadius.br12,
            ),
            6.verticalSpace,
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.text12Bold,
            ),
            2.verticalSpace,
            Text(product.sizeLabel, style: AppTextStyles.text10Regular),
          ],
        ),
      ),
    );
  }
}
