import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/services/location_service.dart';
import 'package:konoz/features/personal_data/data/model/address_model.dart';

part 'addresses_state.dart';

class AddressesCubit extends SafeCubit<AddressesState> {
  // final AddressesRepo _addressesRepo;

  AddressesCubit() : super(const AddressesState());

  // ══════════════ تحديد الموقع على الماب ══════════════

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(locationPickerStatus: LocationPickerStatus.loading));

    try {
      final position = await LocationService.getCurrentLatLng();
      final address = await LocationService.reverseGeocode(position);

      emit(
        state.copyWith(
          locationPickerStatus: LocationPickerStatus.loaded,
          selectedPosition: position,
          resolvedAddress: address,
        ),
      );
    } on LocationServiceDisabledException {
      emit(
        state.copyWith(
          locationPickerStatus: LocationPickerStatus.error,
          locationErrorMessage:
              'خدمة الموقع مقفولة، من فضلك فعّلها من إعدادات الجهاز',
        ),
      );
    } on LocationPermissionDeniedException catch (e) {
      emit(
        state.copyWith(
          locationPickerStatus: LocationPickerStatus.error,
          locationErrorMessage: e.isPermanentlyDenied
              ? 'تم رفض صلاحية الموقع بشكل دائم، من فضلك فعّلها من إعدادات التطبيق'
              : 'محتاجين صلاحية الموقع عشان نحدد عنوانك',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          locationPickerStatus: LocationPickerStatus.error,
          locationErrorMessage: 'حصل خطأ أثناء تحديد موقعك، حاول تاني',
        ),
      );
    }
  }

  Future<void> updateSelectedPosition(LatLng newPosition) async {
    emit(
      state.copyWith(
        locationPickerStatus: LocationPickerStatus.loading,
        selectedPosition: newPosition,
      ),
    );

    try {
      final address = await LocationService.reverseGeocode(newPosition);
      emit(
        state.copyWith(
          locationPickerStatus: LocationPickerStatus.loaded,
          selectedPosition: newPosition,
          resolvedAddress: address,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          locationPickerStatus: LocationPickerStatus.error,
          selectedPosition: newPosition,
          locationErrorMessage: 'تعذر تحديد العنوان',
        ),
      );
    }
  }

  // ══════════════ العناوين المحفوظة من الـ API ══════════════

  // Future<void> getSavedAddresses() async {
  //   emit(state.copyWith(savedAddressesStatus: SavedAddressesStatus.loading));

  //   final result = await _addressesRepo.getAddresses();

  //   result.fold(
  //     (failure) => emit(
  //       state.copyWith(
  //         savedAddressesStatus: SavedAddressesStatus.error,
  //         savedAddressesFailure: failure,
  //       ),
  //     ),
  //     (addresses) => emit(
  //       state.copyWith(
  //         savedAddressesStatus: SavedAddressesStatus.loaded,
  //         savedAddresses: addresses,
  //       ),
  //     ),
  //   );
  // }
}
