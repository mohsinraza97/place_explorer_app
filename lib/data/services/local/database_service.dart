import '../../models/entities/place.dart';

// A database service contract [Usage: SQLite]
abstract class DatabaseService {
  Future<int?> addPlace(Place place);

  Future<List<Place>> getPlaces();

  Future<PlaceLocation?> getPlaceLocation(int? locationId);
}
