import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../resources/app_assets.dart';
import '../../utils/helpers/logger.dart';
import '../../data/models/entities/place.dart';
import '../../utils/utilities/location_utils.dart';
import '../../data/models/ui/page_arguments.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/route_constants.dart';
import '../../utils/utilities/navigation_utils.dart';
import '../resources/app_strings.dart';

class LocationInputWidget extends StatefulWidget {
  final Function(PlaceLocation placeLocation) onLocationPicked;

  const LocationInputWidget(this.onLocationPicked);

  @override
  _LocationInputWidgetState createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  String? _locationPreviewUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 156,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _buildLocationPreview(),
          alignment: Alignment.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.my_location_outlined),
              label: Text(AppStrings.current_location),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentLocation,
            ),
            SizedBox(width: 16),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text(AppStrings.select_from_map),
              textColor: Theme.of(context).primaryColor,
              onPressed: _openMapPage,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLocationPreview() {
    if (_locationPreviewUrl != null) {
      return Image.network(
        _locationPreviewUrl!,
        fit: BoxFit.fill,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          Logger.error(
            'LocationInputWidget',
            '_buildLocationPreview',
            error.toString(),
          );
          return Image.asset(AppAssets.image_no_image);
        },
      );
    }
    return const Text(
      AppStrings.no_location,
      textAlign: TextAlign.center,
    );
  }

  Future<void> _getCurrentLocation() async {
    final location = await Location().getLocation();
    await _setLocationPreview(
      location.latitude ?? 0,
      location.longitude ?? 0,
    );
  }

  Future<void> _openMapPage() async {
    final selectedLocation = await NavigationUtils.push(
      context,
      RouteConstants.map,
      awaitsResult: true,
      args: PageArguments(data: {
        AppConstants.key_selection: true,
      }),
    );
    if (selectedLocation != null && selectedLocation is LatLng) {
      await _setLocationPreview(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
    }
  }

  Future<void> _setLocationPreview(double lat, double lng) async {
    String previewImage = LocationUtils.getLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _locationPreviewUrl = previewImage;
    });
    await _setPlaceLocation(lat, lng);
  }

  Future<void> _setPlaceLocation(double lat, double lng) async {
    final address = await LocationUtils.getAddressString(
      latitude: lat,
      longitude: lng,
    );
    final placeLoc = PlaceLocation(
      latitude: lat,
      longitude: lng,
      address: address,
    );
    widget.onLocationPicked(placeLoc);
  }
}
