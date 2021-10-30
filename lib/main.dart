import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/app_locator.dart';
import 'ui/view_models/place_view_model.dart';
import 'ui/resources/app_strings.dart';
import 'utils/constants/route_constants.dart';
import 'utils/helpers/app_router.dart';
import 'utils/helpers/logger.dart';

void main() {
  initLocator();
  Logger.init();

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(Application());
  }, (error, trace) {});
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PlaceViewModel(),
      child: MaterialApp(
        title: AppStrings.app_name,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.teal,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: TextStyle(fontSize: 16),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteConstants.home,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
