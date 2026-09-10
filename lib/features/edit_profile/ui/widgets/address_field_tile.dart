// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:konoz/core/helper/app_padding.dart';
// import 'package:konoz/core/theme/app_colors.dart';
// import 'package:konoz/core/theme/app_radius.dart';
// import 'package:konoz/core/theme/app_text_style.dart';
// import 'package:konoz/features/edit_profile/data/model/address_model.dart';
 
// /// حقل شكله زي أي AppTextFormField بس مش قابل للكتابة المباشرة،
// /// الضغط عليه هو اللي بيفتح شاشة الماب.
// class AddressFieldTile extends StatelessWidget {
//   final AddressModel? address;
//   final VoidCallback onTap;

//   const AddressFieldTile({super.key, required this.address, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("العنوان", style: AppTextStyles.text14Regular),
//         8.verticalSpace,
//         InkWell(
//           borderRadius: AppRadius.br12,
//           onTap: onTap,
//           child: Container(
//             width: double.infinity,
//             padding: paddingSymmetric(16, 14),
//             decoration: BoxDecoration(
//               color: Colors.white30,
//               borderRadius: AppRadius.br12,
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.location_on_outlined,
//                   size: 18.sp,
//                   color: AppColors.primary,
//                 ),
//                 8.horizontalSpace,
//                 Expanded(
//                   child: Text(
//                     address?.displayText ?? "اختر موقعك من الخريطة",
//                     style: AppTextStyles.text12Regular.copyWith(
//                       color: address == null ? Colors.white60 : null,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Icon(Icons.chevron_right, size: 18.sp, color: Colors.white60),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }