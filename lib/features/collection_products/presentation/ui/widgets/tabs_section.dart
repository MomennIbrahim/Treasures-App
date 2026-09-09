import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/collection_products/data/model/category_model.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/category_tab_item.dart';

class TabsSection extends StatefulWidget {
  const TabsSection({super.key});

  @override
  State<TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<TabsSection> {
  // بيانات مؤقتة (dummy) لحد ما نوصل الـ API - هتتشال بعدين
  final List<CategoryModel> _categories = const [
    CategoryModel.all,
    CategoryModel(id: 1, name: "Men"),
    CategoryModel(id: 2, name: "Women"),
    CategoryModel(id: 3, name: "Unisex"),
    CategoryModel(id: 4, name: "Oud"),
    CategoryModel(id: 5, name: "Kids"),
  ];

  CategoryModel _selectedCategory = CategoryModel.all;

  void _onCategorySelected(CategoryModel category) {
    if (category.id == _selectedCategory.id) return;
    setState(() => _selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      floating: true,
      snap: true,
      toolbarHeight: 37.h,
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: paddingHorizontal(16),
            itemCount: _categories.length,
            separatorBuilder: (context, index) => 8.horizontalSpace,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category.id == _selectedCategory.id;

              return CategoryChip(
                label: category.name,
                isSelected: isSelected,
                onTap: () => _onCategorySelected(category),
              );
            },
          ),
        ),
      ),
    );
  }
}
