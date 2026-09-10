// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:konoz/core/theme/app_colors.dart';
// import 'package:konoz/core/widgets/app_button.dart';
// import 'package:konoz/features/edit_profile/data/model/address_model.dart';
// import 'package:konoz/features/edit_profile/ui/widgets/address_details_sheet.dart';
// import 'package:konoz/features/edit_profile/ui/widgets/address_map_overlay.dart';

// /// الإحداثيات الافتراضية لو المستخدم رفض صلاحية الموقع (القاهرة مثلاً).
// const _fallbackLocation = LatLng(30.0444, 31.2357);

// class AddressPickerScreen extends StatefulWidget {
//   final AddressModel? initialAddress;

//   const AddressPickerScreen({super.key, this.initialAddress});

//   @override
//   State<AddressPickerScreen> createState() => _AddressPickerScreenState();
// }

// class _AddressPickerScreenState extends State<AddressPickerScreen> {
//   GoogleMapController? _mapController;
//   LatLng _currentCenter = _fallbackLocation;
//   String? _resolvedAddress;
//   bool _isResolvingAddress = false;
//   bool _isConfirming = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialAddress != null) {
//       _currentCenter = LatLng(
//         widget.initialAddress!.latitude,
//         widget.initialAddress!.longitude,
//       );
//       _resolvedAddress = widget.initialAddress!.formattedAddress;
//     } else {
//       _resolveCurrentLocation();
//     }
//   }

//   Future<void> _resolveCurrentLocation() async {
//     try {
//       final permission = await Geolocator.checkPermission();
//       var effectivePermission = permission;
//       if (effectivePermission == LocationPermission.denied) {
//         effectivePermission = await Geolocator.requestPermission();
//       }

//       if (effectivePermission == LocationPermission.denied ||
//           effectivePermission == LocationPermission.deniedForever) {
//         _reverseGeocode(_fallbackLocation);
//         return;
//       }

//       final position = await Geolocator.getCurrentPosition();
//       final target = LatLng(position.latitude, position.longitude);

//       setState(() => _currentCenter = target);
//       _mapController?.animateCamera(CameraUpdate.newLatLng(target));
//       _reverseGeocode(target);
//     } catch (_) {
//       _reverseGeocode(_fallbackLocation);
//     }
//   }

//   Future<void> _reverseGeocode(LatLng position) async {
//     setState(() => _isResolvingAddress = true);
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       final placemark = placemarks.first;
//       final address = [
//         placemark.street,
//         placemark.subLocality,
//         placemark.locality,
//       ].where((part) => part != null && part.trim().isNotEmpty).join('، ');

//       if (!mounted) return;
//       setState(() {
//         _resolvedAddress = address.isEmpty ? "موقع غير معروف" : address;
//         _isResolvingAddress = false;
//       });
//     } catch (_) {
//       if (!mounted) return;
//       setState(() {
//         _resolvedAddress = "تعذر تحديد العنوان";
//         _isResolvingAddress = false;
//       });
//     }
//   }

//   Future<void> _onConfirmLocation() async {
//     if (_resolvedAddress == null || _isResolvingAddress) return;

//     final extraDetails = await showAddressDetailsSheet(
//       context: context,
//       formattedAddress: _resolvedAddress!,
//     );

//     // المستخدم لغى الـ bottom sheet
//     if (extraDetails == null) return;
//     if (!mounted) return;

//     setState(() => _isConfirming = true);

//     final result = AddressModel(
//       latitude: _currentCenter.latitude,
//       longitude: _currentCenter.longitude,
//       formattedAddress: _resolvedAddress!,
//       extraDetails: extraDetails.isEmpty ? null : extraDetails,
//     );

//     if (!mounted) return;
//     context.pop(result);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _currentCenter,
//               zoom: 16,
//             ),
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//             onMapCreated: (controller) => _mapController = controller,
//             onCameraMove: (position) => _currentCenter = position.target,
//             onCameraIdle: () => _reverseGeocode(_currentCenter),
//           ),
//           const FixedCenterPin(),
//           AddressLoadingCard(
//             isLoading: _isResolvingAddress,
//             address: _resolvedAddress,
//           ),
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 8.h,
//             left: 8.w,
//             child: CircleAvatar(
//               backgroundColor: AppColors.white,
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => context.pop(),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 24.h,
//             left: 16.w,
//             right: 16.w,
//             child: AppButton(
//               label: "تأكيد الموقع",
//               isLoading: _isConfirming,
//               onPressed: _onConfirmLocation,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
