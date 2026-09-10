// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:konoz/core/helper/app_padding.dart';
// import 'package:konoz/core/theme/app_colors.dart';
// import 'package:konoz/core/theme/app_text_style.dart';
// import 'package:konoz/core/widgets/app_button.dart';
// import 'package:konoz/core/widgets/app_text_form_field.dart';

// /// بيرجع النص اللي كتبه المستخدم (زي "شقة 12 عقار 27")، أو null لو ألغى.
// Future<String?> showAddressDetailsSheet({
//   required BuildContext context,
//   required String formattedAddress,
// }) {
//   final controller = TextEditingController();

//   return showModalBottomSheet<String>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return Padding(
//         padding: paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: paddingAll(20),
//           decoration: BoxDecoration(
//             color: AppColors.black,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r),
//               topRight: Radius.circular(20.r),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("تأكيد العنوان", style: AppTextStyles.text18Bold),
//               8.verticalSpace,
//               Text(formattedAddress, style: AppTextStyles.text12Regular),
//               20.verticalSpace,
//               AppTextFormField(
//                 label: "تفاصيل إضافية (اختياري)",
//                 hint: "شقة 12، عقار 27، الدور الثالث",
//                 controller: controller,
//                 textInputAction: TextInputAction.done,
//               ),
//               20.verticalSpace,
//               SizedBox(
//                 width: double.infinity,
//                 child: AppButton(
//                   label: "حفظ العنوان",
//                   onPressed: () {
//                     Navigator.pop(context, controller.text.trim());
//                   },
//                 ),
//               ),
//               8.verticalSpace,
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
