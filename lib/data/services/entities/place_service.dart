import '../../models/entities/place.dart';

abstract class PlaceService {
  Future<int?> addPlace(Place place);

  Future<List<Place>> getPlaces();
}
