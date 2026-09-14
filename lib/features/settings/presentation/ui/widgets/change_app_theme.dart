import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/layout/presentation/controller/layout_cubit.dart';

class ChangeAppTheme extends StatelessWidget {
  const ChangeAppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<LayoutCubit>().state.themeMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07),
        borderRadius: AppRadius.br24,
      ),
      child: Row(
        children: [
          _changeThemeCard(
            context: context,
            title: "Light Theme",
            isSelected: currentTheme == ThemeMode.light,
            onTap: () {
              context.read<LayoutCubit>().changeTheme(ThemeMode.light);
            },
          ),
          _changeThemeCard(
            context: context,
            title: "Dark Theme",
            isSelected: currentTheme == ThemeMode.dark,
            onTap: () {
              context.read<LayoutCubit>().changeTheme(ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }

  Expanded _changeThemeCard({
    required BuildContext context,
    required VoidCallback onTap,
    required String title,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: paddingAll(6),
          margin: paddingAll(12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surface,
            borderRadius: AppRadius.br24,
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.text14Bold.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontSize: isSelected ? 14.sp : 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
