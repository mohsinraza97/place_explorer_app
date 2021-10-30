import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../ui/pages/map_page.dart';
import '../constants/app_constants.dart';
import '../../ui/pages/add_place_page.dart';
import '../../ui/pages/place_detail_page.dart';
import '../../ui/pages/place_listing_page.dart';
import '../../data/models/ui/page_arguments.dart';
import '../constants/route_constants.dart';
import 'logger.dart';

class AppRouter {
  const AppRouter._internal();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final route = settings.name;
    final args = settings.arguments as PageArguments?;
    Logger.debug(
      'AppRouter',
      'generateRoute',
      '$route, ${args?.toJson()}',
    );

    if (route == RouteConstants.home) {
      // Initial route doesn't requires transition
      return MaterialPageRoute(
        builder: (ctx) => PlaceListingPage(),
      );
    } else if (route == RouteConstants.place_detail) {
      final place = args?.data;
      return _getPageRoute(
        PlaceDetailPage(place),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.add_place) {
      return _getPageRoute(
        AddPlacePage(),
        transitionType: args?.transitionType,
      );
    } else if (route == RouteConstants.map) {
      final location = args?.data[AppConstants.key_initial_location];
      final selectionFlag = args?.data[AppConstants.key_selection];
      return _getPageRoute(
        MapPage(initialLocation: location, isSelection: selectionFlag),
        transitionType: args?.transitionType,
      );
    }
  }

  static PageTransition<dynamic> _getPageRoute(
    Widget page, {
    PageTransitionType? transitionType,
    RouteSettings? settings,
  }) {
    // If null, set a default transition
    if (transitionType == null) {
      transitionType = PageTransitionType.fade;
    }
    return PageTransition(
      type: transitionType,
      child: page,
      settings: settings,
    );
  }
}
