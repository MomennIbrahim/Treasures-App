import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konoz/core/services/location_service.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/features/personal_data/presentation/controllers/addresses/addresses_cubit.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/confirm_location_button.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/fixed_center_pin.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/map_header.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _pendingCameraTarget = LocationService.fallbackLocation;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    context.read<AddressesCubit>().getCurrentLocation();
  }

  bool _styleLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_styleLoaded) {
      _styleLoaded = true;
      _loadMapStyle();
    }
  }

  Future<void> _loadMapStyle() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark) return; // في اللايت مود سيب الستايل الافتراضي زي ما هو

    final style = await rootBundle.loadString(
      'assets/map_styles/dark_map_style.json',
    );
    if (!mounted) return;
    setState(() => _mapStyle = style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AddressesCubit, AddressesState>(
        // لما الموقع يتحدد لأول مرة (من getCurrentLocation)، حرّك الكاميرا فعليًا
        listenWhen: (previous, current) =>
            previous.selectedPosition != current.selectedPosition,
        listener: (context, state) {
          final position = state.selectedPosition;
          if (position != null) {
            _pendingCameraTarget = position;
            _mapController?.animateCamera(CameraUpdate.newLatLng(position));
          }
        },
        builder: (context, state) {
          final initialTarget =
              state.selectedPosition ?? LocationService.fallbackLocation;

          return Stack(
            children: [
              _buildMapWidget(initialTarget, context),

              // الدبوس الثابت في نص الشاشة — بيمثل بصريًا مركز الماب دايمًا
              const FixedCenterPin(),

              // مؤشر تحميل بسيط وقت ما بنجيب العنوان
              if (state.isPickingLocationLoading)
                const Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: AppLoading(),
                ),

              ConfirmLocationButton(),

              // Header
              MapHeader(addressResult: state.resolvedAddress),
            ],
          );
        },
      ),
    );
  }

  GoogleMap _buildMapWidget(LatLng initialTarget, BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialTarget, zoom: 16),
      style: _mapStyle,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
      }, // بنتابع مكان مركز الماب أول بأول من غير ما ننادي الكيوبت
      onCameraMove: (position) => _pendingCameraTarget = position.target,
      // وبس لما المستخدم يسيب إصبعه، نبعت المكان النهائي للكيوبت
      onCameraIdle: () => context.read<AddressesCubit>().updateSelectedPosition(
        _pendingCameraTarget,
      ),
    );
  }
}
