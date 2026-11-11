import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/features/package_details/ui/widgets/package_bottom_bar.dart';
import 'package:konoz/features/package_details/ui/widgets/package_description_section.dart';
import 'package:konoz/features/package_details/ui/widgets/package_images_header.dart';
import 'package:konoz/features/package_details/ui/widgets/package_info_section.dart';
import 'package:konoz/features/package_details/ui/widgets/package_products_section.dart';

class PackageDetailsScreen extends StatelessWidget {
  /// لو null بيستخدم داتا مؤقتة (TODO: شيلها لما الـ API يجهز)
  final PackageDetailsModel? package;

  const PackageDetailsScreen({super.key, this.package});

  @override
  Widget build(BuildContext context) {
    final pkg = package ?? PackageDetailsModel.mock();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: paddingOnly(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PackageImagesHeader(images: pkg.images),
                  PackageInfoSection(package: pkg),
                  PackageProductsSection(products: pkg.products),
                  PackageDescriptionSection(package: pkg),
                ],
              ),
            ),
            PackageBottomBar(package: pkg),
          ],
        ),
      ),
    );
  }
}
