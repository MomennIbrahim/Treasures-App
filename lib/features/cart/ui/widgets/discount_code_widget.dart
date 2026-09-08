// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:konoz/core/helper/app_padding.dart';
// import 'package:konoz/core/theme/app_colors.dart';
 

// class DiscountCodeWidget extends StatefulWidget {
//   const DiscountCodeWidget({super.key});

//   @override
//   State<DiscountCodeWidget> createState() => _DiscountCodeWidgetState();
// }

// class _DiscountCodeWidgetState extends State<DiscountCodeWidget> {
//   late final TextEditingController _codeController;
//   late final GlobalKey<FormState> _formKey;

//   @override
//   void initState() {
//     _codeController = TextEditingController();
//     _formKey = GlobalKey<FormState>();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: paddingVertical(20),
//       padding: paddingAll(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: 20.borderRadius,
//       ),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               LocaleKeys.discount_code.tr(),
//               style: AppTextStyles.font14W400,
//             ),
//             15.0.height,
//             BlocConsumer<ApplyCouponCubit, ApplyCouponState>(
//               listener: (context, state) {
//                 if (state.isFailure) {
//                   ToastHelper.showToast(
//                     context: context,
//                     message: state.failure?.message ?? '',
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 // Success State - تم التفعيل
//                 if (state.applyCouponModel != null &&
//                     !state.isLoading &&
//                     !state.isFailure) {
//                   return Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         state.applyCouponModel?.coupon?.code ?? '',
//                         style: AppTextStyles.font12W400.copyWith(
//                           color: AppColors.moreGreenColor,
//                         ),
//                       ),
//                       10.0.width,
//                       Expanded(
//                         child: Text(
//                           "(${state.applyCouponModel?.coupon?.value.toString() ?? ''}%)",
//                           style: AppTextStyles.font12W400.copyWith(
//                             color: AppColors.moreGreenColor,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: paddingAll(10),
//                         decoration: BoxDecoration(
//                           borderRadius: 50.borderRadius,
//                           color: const Color(0xff3FA65C),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.check_circle_outlined,
//                               color: AppColors.whiteColor,
//                               size: 14.0.sp,
//                             ),
//                             4.0.width,
//                             Text(
//                               LocaleKeys.code_activated.tr(),
//                               style: AppTextStyles.font12W700White,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }

//                 // Default State - Input Field
//                 return Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: AppTextFormField(
//                             controller: _codeController,
//                             hintText: LocaleKeys.discount_code.tr(),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return LocaleKeys.enter_valid_code.tr();
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         10.0.width,
//                         AppButton(
//                           width: 90,
//                           padding: 0,
//                           height: 35,
//                           text: LocaleKeys.apply.tr(),
//                           buttonColor: AppColors.purpleColor,
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               context.read<ApplyCouponCubit>().applyCoupon(
//                                 coupon: _codeController.text,
//                                 cartId: context
//                                     .read<CartCubit>()
//                                     .state
//                                     .cartModel!
//                                     .cartId!,
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),

//                     // Loading State - Linear Progress
//                     if (state.isLoading) ...[
//                       10.0.height,
//                       const LinearProgressIndicator(),
//                     ],
//                     // Error State
//                     if (state.isFailure && !state.isLoading) ...[
//                       10.0.height,
//                       ErrorText(errorText: LocaleKeys.invalid_code.tr()),
//                     ],
//                   ],
//                 );
//               },
//             ),
//             if (context.watch<ApplyCouponCubit>().state.applyCouponModel !=
//                 null)
//               Row(
//                 children: [
//                   Text(
//                     LocaleKeys.discount_value.tr(),
//                     style: AppTextStyles.font14W400,
//                   ),
//                   10.0.width,
//                   Text(
//                     context
//                             .watch<ApplyCouponCubit>()
//                             .state
//                             .applyCouponModel
//                             ?.discount
//                             .toString() ??
//                         '',
//                     style: AppTextStyles.font14W700,
//                   ),
//                   4.0.width,
//                   const CurrencyImage(
//                     width: 12,
//                     color: AppColors.darkBlueColor,
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
