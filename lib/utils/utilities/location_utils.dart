import 'package:geocode/geocode.dart';
import '../helpers/logger.dart';
import '../constants/app_constants.dart';

class LocationUtils {
  const LocationUtils._internal();

  static String getLocationPreviewImage({
    double latitude = 0,
    double longitude = 0,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=18&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${AppConstants.google_api_key}';
  }

  static Future<String?> getAddressString({
    double latitude = 0,
    double longitude = 0,
  }) async {
    try {
      final geoCode = GeoCode();
      final address = await geoCode.reverseGeocoding(
        latitude: latitude,
        longitude: longitude,
      );
      final stNumber = address.streetNumber;
      final stAddress = address.streetAddress;
      final city = address.city;
      final region = address.region;
      final country = address.countryName;
      return 'St $stNumber, $stAddress, $region, $country';
    } on Exception catch (e) {
      Logger.error('LocationUtils', 'getAddressString', e);
      return null;
    }
  }
}
