import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Check if location services are enabled and permissions are granted
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current GPS location
  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        print('Location permission denied');
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Got location: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Convert coordinates to address (reverse geocoding)
  Future<Map<String, String>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return {
          'locality': place.locality ?? '',
          'administrativeArea': place.administrativeArea ?? '', // State
          'country': place.country ?? '',
          'postalCode': place.postalCode ?? '',
          'subAdministrativeArea': place.subAdministrativeArea ?? '', // District
        };
      }

      return {};
    } catch (e) {
      print('Error reverse geocoding: $e');
      return {};
    }
  }

  /// Get formatted address string
  Future<String> getFormattedAddress(double latitude, double longitude) async {
    Map<String, String> address = await getAddressFromCoordinates(
      latitude,
      longitude,
    );

    String locality = address['locality'] ?? '';
    String state = address['administrativeArea'] ?? '';
    String country = address['country'] ?? '';

    List<String> parts = [];
    if (locality.isNotEmpty) parts.add(locality);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);

    return parts.join(', ');
  }

  /// Get location with address
  Future<Map<String, dynamic>?> getLocationWithAddress() async {
    Position? position = await getCurrentLocation();
    if (position == null) return null;

    String address = await getFormattedAddress(
      position.latitude,
      position.longitude,
    );

    Map<String, String> addressDetails = await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
      'locality': addressDetails['locality'] ?? '',
      'state': addressDetails['administrativeArea'] ?? '',
      'country': addressDetails['country'] ?? '',
    };
  }
}
