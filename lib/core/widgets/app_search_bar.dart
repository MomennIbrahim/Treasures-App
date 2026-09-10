import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/home/presentation/ui/widgets/search_card.dart';

class AppSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final String? title;
  const AppSearchBar({super.key, this.showBackIcon = false, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
        child: Padding(
          padding: paddingOnly(left: 16, bottom: 12),
          child: Row(
            children: [
              if (showBackIcon) CustomBackIcon(),
              Expanded(child: SearchCard(title: title)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(65.h);
}
