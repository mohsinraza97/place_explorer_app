import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../data/models/ui/page_arguments.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/route_constants.dart';
import '../../utils/utilities/navigation_utils.dart';
import '../resources/app_strings.dart';
import '../../data/models/entities/place.dart';

class PlaceDetailPage extends StatelessWidget {
  final Place? place;

  const PlaceDetailPage(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place?.title ?? AppStrings.title_place_detail),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final image = place?.image ?? null;
    final address = place?.location?.address ?? null;

    return Column(
      children: [
        if (image != null)
          Container(
            height: 220,
            width: double.infinity,
            child: Image.file(image, fit: BoxFit.fill),
          ),
        if (address != null)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Text(
                  address,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              FlatButton(
                child: Text(AppStrings.view_on_map.toUpperCase()),
                textColor: Theme.of(context).primaryColor,
                onPressed: () => _openMapPage(context),
              ),
            ],
          ),
      ],
    );
  }

  void _openMapPage(BuildContext context) {
    NavigationUtils.push(
      context,
      RouteConstants.map,
      args: PageArguments(
        data: {
          AppConstants.key_selection: false,
          AppConstants.key_initial_location: place?.location,
        },
        transitionType: PageTransitionType.rightToLeft,
      ),
    );
  }
}
