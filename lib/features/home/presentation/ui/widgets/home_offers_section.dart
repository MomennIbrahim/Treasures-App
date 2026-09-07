import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_slider.dart';

class HomeOffersSection extends StatelessWidget {
  const HomeOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingHorizontal(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Exclusive Offers 🔥", style: AppTextStyles.text14Bold),
            10.verticalSpace,
            AppSlider(
              items: [
                ImageBannerItem(
                  imagePath:
                      'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',
                  title: 'New perfume collection 2026',
                  subtitle: 'Choose perfect perfume for your life style',
                  buttonLabel: 'Discover',
                  onPressed: () {},
                ),
                ImageBannerItem(
                  imagePath:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRylEOduNlj_SZdJbNm7k0KUS_18QdEHPjFWM8gcj2SHwGJBzueARYk_50&s=10',
                  title: 'Limited Edition',
                  subtitle: 'Exclusive scents crafted for you',
                  buttonLabel: 'Discover',
                  onPressed: () {},
                ),
                ImageBannerItem(
                  imagePath:
                      'https://img.pikbest.com/wp/202413/aroma-men-s-perfume-plant-leaves-promotional-web-banner_9087731.jpg!sw800',
                  title: 'Limited Edition',
                  subtitle: 'Exclusive scents crafted for you',
                  buttonLabel: 'Discover',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
