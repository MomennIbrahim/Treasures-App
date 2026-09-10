// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:konoz/core/constance/images_paths.dart';
// import 'package:konoz/core/helper/app_padding.dart';
// import 'package:konoz/core/theme/app_colors.dart';
// import 'package:konoz/core/theme/app_radius.dart';
// import 'package:konoz/core/theme/app_text_style.dart';
// import 'package:konoz/core/widgets/app_image.dart';

// /// كارت شفاف فوق الماب بيعرض العنوان الحالي (أو حالة تحميل)
// /// بينزل فوق نص الشاشة تحديدًا، وبيتحرك مع كل تحديث للعنوان.
// class AddressLoadingCard extends StatelessWidget {
//   final bool isLoading;
//   final String? address;

//   const AddressLoadingCard({
//     super.key,
//     required this.isLoading,
//     required this.address,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 60.h,
//       left: 16.w,
//       right: 16.w,
//       child: Container(
//         padding: paddingSymmetric(16, 12),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: AppRadius.br12,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.15),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.location_on, color: AppColors.primary, size: 20.sp),
//             8.horizontalSpace,
//             Expanded(
//               child: isLoading
//                   ? Text(
//                       "جاري تحديد العنوان...",
//                       style: AppTextStyles.text12Regular,
//                     )
//                   : Text(
//                       address ?? "حرّك الخريطة لتحديد موقعك",
//                       style: AppTextStyles.text12Bold.copyWith(
//                         color: AppColors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// الدبوس الثابت في نص الشاشة، فوق الماب مباشرة، مش جزء من الـ GoogleMap
// /// نفسه (مش Marker) عشان يفضل ثابت بصريًا وقت ما المستخدم بيسحب الخريطة.
// class FixedCenterPin extends StatelessWidget {
//   const FixedCenterPin({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Center(
//         child: Padding(
//           // بنرفعه لفوق بمقدار نص ارتفاعه عشان طرف الدبوس (مش نص الأيقونة)
//           // هو اللي يمثل النقطة الفعلية على الخريطة.
//           padding: paddingOnly(bottom: 16),
//           child: AppImage.asset(ImagesPaths.pin, width: 48),
//         ),
//       ),
//     );
//   }
// }
