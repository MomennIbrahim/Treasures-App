import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currenttly_trending_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_header.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_offers_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/packages_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCount();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnly(bottom: 16),
      child: CustomScrollView(
        slivers: [
          HomeHeader(),
          HomeOffersSection(),
          CurrenttlyTrendingSection(),
          BestSellingSection(),
          PackagesSection(),
          const SliverToBoxAdapter(
            child: SafeArea(top: false, child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
