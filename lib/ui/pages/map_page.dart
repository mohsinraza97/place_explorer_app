import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/utilities/navigation_utils.dart';
import '../resources/app_strings.dart';
import '../../data/models/entities/place.dart';

class MapPage extends StatefulWidget {
  final PlaceLocation? initialLocation;
  final bool? isSelection;

  const MapPage({
    this.initialLocation,
    this.isSelection = false,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFABButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _getAppBarTitle() {
    if (widget.isSelection ?? false) {
      return AppStrings.title_map_page;
    }
    return widget.initialLocation?.address ?? '';
  }

  Widget _buildBody() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _getInitialTarget(),
        zoom: 18,
      ),
      markers: _getMarkers(),
      onTap: (widget.isSelection ?? false) ? _setSelectedLocation : null,
    );
  }

  Widget _buildFABButton() {
    return Visibility(
      visible: widget.isSelection ?? false,
      child: FloatingActionButton(
        onPressed: () {
          if (_pickedLocation == null) {
            _pickedLocation = AppConstants.default_location;
          }
          NavigationUtils.pop(context, result: _pickedLocation);
        },
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }

  LatLng _getInitialTarget() {
    return LatLng(
      widget.initialLocation?.latitude ?? 0,
      widget.initialLocation?.longitude ?? 0,
    );
  }

  Set<Marker> _getMarkers() {
    if (_pickedLocation == null && (widget.isSelection ?? false)) {
      return {};
    }
    return {
      Marker(
        markerId: MarkerId('m1'),
        position: _pickedLocation ?? _getInitialTarget(),
      ),
    };
  }

  void _setSelectedLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }
}
