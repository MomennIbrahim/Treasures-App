import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/features/package_details/ui/widgets/package_product_card.dart';
 
/// المنتجات اللي في الباكدج (3 - 6 حسب الداشبورد).
class PackageProductsSection extends StatelessWidget {
  final List<PackageProductModel> products;

  const PackageProductsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: paddingHorizontal(16),
          child: Text(
            'Package contains (${products.length} items)',
            style: AppTextStyles.text14Bold,
          ),
        ),
        10.verticalSpace,
        SizedBox(
          height: 170.h,
          child: ListView.separated(
            padding: paddingHorizontal(16),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, _) => 10.horizontalSpace,
            itemBuilder: (context, index) => FadeInRight(
              from: 30,
              delay: Duration(milliseconds: 100 + index * 80),
              child: PackageProductCard(product: products[index]),
            ),
          ),
        ),
      ],
    );
  }
}
