import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/features/edit_profile/ui/widgets/personal_information_form.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: paddingHorizontal(16),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: paddingVertical(20),
              child: Stack(
                children: [
                  Container(
                    width: 110.0.w,
                    height: 110.0.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(
                                  "https://i.pinimg.com/736x/eb/76/a4/eb76a46ab920d056b02d203ca95e9a22.jpg",
                                )
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5.h,
                    right: 5.w,
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 14.r,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            PersonalInformationForm(),
          ],
        ),
      ),
    );
  }
}
