import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  const AppConstants._internal();

  // region map keys
  static const String key_initial_location = 'key_initial_location';
  static const String key_selection = 'key_selection';
  // endregion

  // region DB Constants
  static const db_name = 'place_explorer.db';
  static const db_version = 1;
  // endregion

  static const default_location = LatLng(24.9275, 67.0641);
  static const google_api_key = '';
}
