import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/description_content.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/how_to_use_content.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/notes_content.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class ProductInformationSection extends StatefulWidget {
  final ProductDetailsModel product;

  const ProductInformationSection({super.key, required this.product});

  @override
  State<ProductInformationSection> createState() =>
      _ProductInformationSectionState();
}

class _ProductInformationSectionState extends State<ProductInformationSection> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    LocaleKeys.product_details_description,
    LocaleKeys.product_details_how_to_use,
    LocaleKeys.product_details_notes,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabs(),
        16.verticalSpace,
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
                  color: Colors.white12,
                  borderRadius: AppRadius.br12,
                  border: Border.all(
                    width: 1.5,
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
                      ? AppTextStyles.text10Bold.copyWith(
                          color: AppColors.primary,
                        )
                      : AppTextStyles.text10Regular.copyWith(
                          color: AppColors.white,
                        ),
                  child: Text(
                    _tabs[index].tr(),
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
        return NotesContent(key: key, notes: widget.product.notes);

      default:
        return const SizedBox.shrink();
    }
  }
}
