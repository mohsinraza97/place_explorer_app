import 'package:get_it/get_it.dart';
import 'services/entities/place_service.dart';
import 'repositories/entities/place_repository.dart';
import 'services/local/database_service.dart';
import 'repositories/local/database_repository.dart';

// Using GetIt is a convenient way to provide objects anywhere we need them in the app
GetIt locator = GetIt.instance;

void initLocator() {
  // services
  locator.registerLazySingleton<DatabaseService>(() => DatabaseRepository());
  locator.registerLazySingleton<PlaceService>(() => PlaceRepository());
}
