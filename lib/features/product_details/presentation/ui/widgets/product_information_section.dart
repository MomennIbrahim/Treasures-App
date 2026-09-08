import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/description_content.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/how_to_use_content.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/ingredients_content.dart';

class ProductInformationSection extends StatefulWidget {
  final ProductDetailsModel product;

  const ProductInformationSection({super.key, required this.product});

  @override
  State<ProductInformationSection> createState() =>
      _ProductInformationSectionState();
}

class _ProductInformationSectionState extends State<ProductInformationSection> {
  int _selectedTab = 0;

  final List<String> _tabs = const ['Description', 'How to use', 'Ingredients'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabs(),
        20.verticalSpace,
        _buildContent(key: ValueKey(_selectedTab)),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final isSelected = _selectedTab == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == _tabs.length - 1 ? 0 : 8.w,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: paddingAll(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.90),
                  borderRadius: AppRadius.br12,
                  border: Border.all(
                    width: 3,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: isSelected
                      ? AppTextStyles.text12Bold.copyWith(
                          color: AppColors.primary,
                        )
                      : AppTextStyles.text12Regular.copyWith(
                          color: AppColors.black,
                        ),
                  child: Text(
                    _tabs[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContent({required Key key}) {
    switch (_selectedTab) {
      case 0:
        return DescriptionContent(key: key, product: widget.product);

      case 1:
        return HowToUseContent(key: key, howToUse: widget.product.howToUse);

      case 2:
        return IngredientsContent(
          key: key,
          ingredients: widget.product.ingredients,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
