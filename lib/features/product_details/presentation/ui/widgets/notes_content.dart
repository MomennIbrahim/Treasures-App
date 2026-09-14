import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class NotesContent extends StatelessWidget {
  final FragranceNotesModel notes;
  const NotesContent({super.key, required this.notes});
  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNotesSection(
          title: LocaleKeys.product_details_top_notes,
          notes: notes.topNotes,
          icon: Icons.keyboard_arrow_up_rounded,
        ),
        16.verticalSpace,
        _buildNotesSection(
          title: LocaleKeys.product_details_heart_notes,
          notes: notes.heartNotes,
          icon: Icons.favorite_border_rounded,
        ),
        16.verticalSpace,
        _buildNotesSection(
          title: LocaleKeys.product_details_base_notes,
          notes: notes.baseNotes,
          icon: Icons.arrow_downward_rounded,
        ),
      ],
    );
  }
}

Widget _buildNotesSection({
  required String title,
  required List<FragranceNoteModel> notes,
  required IconData icon,
}) {
  if (notes.isEmpty) {
    return const SizedBox.shrink();
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedNote04,
            size: 16.sp,
            color: AppColors.white,
          ),
          6.horizontalSpace,
          Text(title.tr(), style: AppTextStyles.text12Bold),
        ],
      ),
      6.verticalSpace,
      Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: List.generate(notes.length, (index) {
          final note = notes[index];
          return ZoomIn(
            delay: Duration(milliseconds: 100 * index),
            child: Container(
              padding: paddingSymmetric(4, 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: AppRadius.br8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppImage.cachedNetwork(
                    note.image,
                    borderRadius: AppRadius.br8,
                    width: 60,
                    height: 60,
                  ),
                  8.verticalSpace,
                  Text(
                    note.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text12Regular,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ],
  );
}
