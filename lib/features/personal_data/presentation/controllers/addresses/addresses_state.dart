part of 'addresses_cubit.dart';

enum LocationPickerStatus { initial, loading, loaded, error }

enum SavedAddressesStatus { initial, loading, loaded, error }

extension AddressesStateX on AddressesState {
  bool get isPickingLocationLoading =>
      locationPickerStatus == LocationPickerStatus.loading;
  bool get isLocationPickSuccess =>
      locationPickerStatus == LocationPickerStatus.loaded;
  bool get isLocationPickFailure =>
      locationPickerStatus == LocationPickerStatus.error;

  bool get isFetchingSavedAddresses =>
      savedAddressesStatus == SavedAddressesStatus.loading;
  bool get isSavedAddressesLoaded =>
      savedAddressesStatus == SavedAddressesStatus.loaded;
  bool get isSavedAddressesError =>
      savedAddressesStatus == SavedAddressesStatus.error;
}

@immutable
class AddressesState extends Equatable {
  // ── تحديد موقع على الماب (GPS + reverse geocoding) ──
  final LocationPickerStatus locationPickerStatus;
  final LatLng? selectedPosition;
  final String? resolvedAddress;
  final String? locationErrorMessage;

  // ── العناوين المحفوظة الجاية من الـ API ──
  final SavedAddressesStatus savedAddressesStatus;
  //  final List<AddressModel> savedAddresses;
  final AppFailure? savedAddressesFailure;

  const AddressesState({
    this.locationPickerStatus = LocationPickerStatus.initial,
    this.selectedPosition,
    this.resolvedAddress,
    this.locationErrorMessage,
    this.savedAddressesStatus = SavedAddressesStatus.initial,
    //  this.savedAddresses = const [],
    this.savedAddressesFailure,
  });

  AddressesState copyWith({
    LocationPickerStatus? locationPickerStatus,
    LatLng? selectedPosition,
    String? resolvedAddress,
    String? locationErrorMessage,
    SavedAddressesStatus? savedAddressesStatus,
    //List<AddressModel>? savedAddresses,
    AppFailure? savedAddressesFailure,
  }) {
    return AddressesState(
      locationPickerStatus: locationPickerStatus ?? this.locationPickerStatus,
      selectedPosition: selectedPosition ?? this.selectedPosition,
      resolvedAddress: resolvedAddress ?? this.resolvedAddress,
      locationErrorMessage: locationErrorMessage,
      savedAddressesStatus: savedAddressesStatus ?? this.savedAddressesStatus,
      // savedAddresses: savedAddresses ?? this.savedAddresses,
      savedAddressesFailure: savedAddressesFailure,
    );
  }

  @override
  List<Object?> get props => [
    locationPickerStatus,
    selectedPosition,
    resolvedAddress,
    locationErrorMessage,
    savedAddressesStatus,
    //  savedAddresses,
    savedAddressesFailure,
  ];
}
