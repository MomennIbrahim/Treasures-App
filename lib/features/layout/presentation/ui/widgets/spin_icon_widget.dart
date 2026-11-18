// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:konoz/core/constance/images_paths.dart';
// import 'package:konoz/core/helper/app_padding.dart';
// import 'package:konoz/core/router/routes.dart';
// import 'package:konoz/core/widgets/app_image.dart';
// import 'package:konoz/features/spin/presentation/controllers/spin/spin_cubit.dart';

// class SpinIconWidget extends StatelessWidget {
//   const SpinIconWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SpinCubit, SpinState>(
//       builder: (context, state) {
//         if (state.isInitial || state.isLoading || !state.isEnabled) {
//           return const SizedBox.shrink();
//         }
//         return Padding(
//           padding: paddingOnly(bottom: 16),
//           child: GestureDetector(
//             onTap: () => context.push(Routes.spin),
//             child: AppImage.asset(ImagesPaths.luckyWheel, width: 40),
//           ),
//         );
//       },
//     );
//   }
// }
