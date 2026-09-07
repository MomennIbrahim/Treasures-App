import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currenttly_trending_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_header.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_offers_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/search_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnly(bottom: 16, top: 8),
      child: CustomScrollView(
        slivers: [
          HomeHeader(),
          SliverToBoxAdapter(child: SearchCard()),
          HomeOffersSection(),
          CurrenttlyTrendingSection(),
          BestSellingSection(),
          SliverToBoxAdapter(
            child: SafeArea(top: false, child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
