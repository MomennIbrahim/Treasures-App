import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationResult {
  final LatLng position;
  final String address;

  const LocationResult({required this.position, required this.address});
}

class LocationPermissionDeniedException implements Exception {
  final bool isPermanentlyDenied;
  const LocationPermissionDeniedException({this.isPermanentlyDenied = false});
}

class LocationServiceDisabledException implements Exception {
  const LocationServiceDisabledException();
}

class LocationService {
  LocationService._();

  static const LatLng fallbackLocation = LatLng(30.0444, 31.2357);

  // ✅ إنستانس واحد من كلاس Geocoding (النسخة 5.0.0)
  static final Geocoding _geocoding = Geocoding();

  static Future<void> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationPermissionDeniedException();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedException(isPermanentlyDenied: true);
    }
  }

  static Future<LatLng> getCurrentLatLng() async {
    await ensurePermission();
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LatLng(position.latitude, position.longitude);
  }

  /// بيحول إحداثيات لعنوان نصي مقروء (شارع، حي، مدينة).
  static Future<String> reverseGeocode(LatLng position) async {
    try {
      // ✅ بقى بينادى على الإنستانس مش top-level function
      final placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return "موقع غير معروف";

      final placemark = placemarks.first;
      final parts = [
        placemark.street,
        placemark.subLocality,
        placemark.locality,
      ].where((part) => part != null && part.trim().isNotEmpty);

      final address = parts.join('، ');
      return address.isEmpty ? "موقع غير معروف" : address;
    } catch (_) {
      return "تعذر تحديد العنوان";
    }
  }

  static Future<LocationResult> getCurrentLocationWithAddress() async {
    LatLng target;
    try {
      target = await getCurrentLatLng();
    } catch (_) {
      target = fallbackLocation;
    }

    final address = await reverseGeocode(target);
    return LocationResult(position: target, address: address);
  }
}
