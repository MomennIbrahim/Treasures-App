import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/home/presentation/controllers/best_selling/best_selling_cubit.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_listview_horizontal.dart';

class BestSellingSection extends StatefulWidget {
  const BestSellingSection({super.key});

  @override
  State<BestSellingSection> createState() => _BestSellingSectionState();
}

class _BestSellingSectionState extends State<BestSellingSection> {
  @override
  void initState() {
    super.initState();
    context.read<BestSellingCubit>().getBestSelling();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocConsumer<BestSellingCubit, BestSellingState>(
        listener: (context, state) {
          if (state.isFailure && state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure!.getAllError())),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state.isLoading || state.isInitial;

          final products = state.bestSelling?.products ?? [];

          if (products.isEmpty && !isLoading) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingOnly(left: 16, right: 16, top: 16, bottom: 4),
                child: Text('Best Selling', style: AppTextStyles.text14Bold),
              ),
              10.verticalSpace,
              BestSellingListviewHorizontal(
                products: products,
                isLoading: isLoading,
              ),
            ],
          );
        },
      ),
    );
  }
}
