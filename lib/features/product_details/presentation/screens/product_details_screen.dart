import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppSearchBar(showBackIcon: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 300.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: CachedNetworkImageProvider(
                    'https://i.pinimg.com/1200x/00/d7/35/00d7353072bc5431db22de9ccec0b965.jpg',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
