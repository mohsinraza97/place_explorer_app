import '../../models/entities/place.dart';
import '../../services/entities/place_service.dart';
import '../base_repository.dart';

class PlaceRepository extends BaseRepository implements PlaceService {
  @override
  Future<int?> addPlace(Place place) async {
    final id = await databaseService.addPlace(place);
    return id;
  }

  @override
  Future<List<Place>> getPlaces() async {
    final places = await databaseService.getPlaces();
    return places;
  }
}
