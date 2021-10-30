import 'database_client.dart';
import '../../models/entities/place.dart';
import '../../services/local/database_service.dart';

// A concrete implementation to database service contract
class DatabaseRepository implements DatabaseService {
  @override
  Future<int?> addPlace(Place place) async {
    if (place.location != null) {
      final locationId = await DatabaseClient.instance.insert(
        PlaceLocation.table_name,
        place.location!.toJson(),
      );
      place.locationId = locationId;
    }
    final placeId = await DatabaseClient.instance.insert(
      Place.table_name,
      place.toJson(),
    );
    return placeId;
  }

  @override
  Future<List<Place>> getPlaces() async {
    List<Place> places = [];
    final values = await DatabaseClient.instance.fetch(
      Place.table_name,
      orderBy: '${Place.field_id} ASC',
    );
    if (values != null) {
      for (final json in values) {
        final place = Place.fromJson(json);
        place.location = await getPlaceLocation(place.locationId);
        places.add(place);
      }
    }
    return places;
  }

  @override
  Future<PlaceLocation?> getPlaceLocation(int? locationId) async {
    if (locationId != null) {
      final values = await DatabaseClient.instance.fetch(
        PlaceLocation.table_name,
        where: '${PlaceLocation.field_id} = ?',
        whereArgs: [locationId],
      );
      final location = values?.first;
      if (location != null) {
        return PlaceLocation.fromJson(location);
      }
    }
    return null;
  }
}
