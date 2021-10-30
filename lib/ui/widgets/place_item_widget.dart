import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../data/models/ui/page_arguments.dart';
import '../../utils/constants/route_constants.dart';
import '../../utils/utilities/navigation_utils.dart';
import '../resources/app_assets.dart';
import '../../data/models/entities/place.dart';

class PlaceItemWidget extends StatelessWidget {
  final Place place;

  const PlaceItemWidget(this.place);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: CircleAvatar(
        backgroundImage: _buildPlaceImage(),
        radius: 32,
      ),
      title: Text(place.title ?? ''),
      subtitle: Visibility(
        visible: place.location != null,
        child: Text(place.location?.address ?? ''),
      ),
      onTap: () => _openPlaceDetail(context),
    );
  }

  ImageProvider _buildPlaceImage() {
    if (place.image == null) {
      return AssetImage(AppAssets.image_no_image);
    }
    return FileImage(place.image!);
  }

  void _openPlaceDetail(BuildContext context) {
    NavigationUtils.push(
      context,
      RouteConstants.place_detail,
      args: PageArguments(
        data: place,
        transitionType: PageTransitionType.rightToLeft,
      ),
    );
  }
}
