import '../../data/app_locator.dart';
import '../../data/services/entities/place_service.dart';
import '../../data/models/entities/place.dart';
import 'base_view_model.dart';

class PlaceViewModel extends BaseViewModel {
  final _placeService = locator<PlaceService>();
  List<Place> _places = [];

  List<Place> get places {
    // Return a copy of the list
    return [..._places];
  }

  Place? findById(int? id) {
    return _places.firstWhere((p) => p.id == id);
  }

  Future<bool> addPlace(Place place) async {
    final id = await _placeService.addPlace(place);
    if (id != null) {
      await fetchPlaces();
      return true;
    }
    return false;
  }

  Future<void> fetchPlaces() async {
    final places = await _placeService.getPlaces();
    _places.clear();
    _places.addAll(places);
    notifyListeners();
  }
}
