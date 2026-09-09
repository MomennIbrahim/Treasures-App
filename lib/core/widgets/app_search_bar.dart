import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/features/home/presentation/ui/widgets/search_card.dart';

class AppSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  const AppSearchBar({super.key, this.showBackIcon = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              if (showBackIcon)
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                ),
              Expanded(child: SearchCard()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
