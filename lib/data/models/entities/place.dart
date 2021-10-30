import 'dart:io';

import '../base_model.dart';

class Place extends BaseModel {
  static const String table_name = 'Place';
  static const String field_id = 'ID';
  static const String field_title = 'Title';
  static const String field_image = 'Image';
  static const String field_location_id = 'Location_ID';

  int? id;
  String? title;
  File? image;
  int? locationId;

  Place({
    this.id,
    this.title,
    this.image,
    this.locationId,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json[field_id],
      title: json[field_title],
      image: json[field_image] == null ? null : File(json[field_image]),
      locationId: json[field_location_id],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      field_id: id,
      field_title: title,
      field_image: image?.path,
      field_location_id: locationId
    };
  }

  PlaceLocation? _location;

  PlaceLocation? get location => _location;

  set location(PlaceLocation? value) {
    _location = value;
  }
}

class PlaceLocation extends BaseModel {
  static const String table_name = 'PlaceLocation';
  static const String field_id = 'ID';
  static const String field_latitude = 'Latitude';
  static const String field_longitude = 'Longitude';
  static const String field_address = 'Address';

  int? id;
  double? latitude;
  double? longitude;
  String? address;

  PlaceLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      id: json[field_id],
      latitude: json[field_latitude] ?? 0,
      longitude: json[field_longitude] ?? 0,
      address: json[field_address],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      field_id: id,
      field_latitude: latitude ?? 0,
      field_longitude: longitude ?? 0,
      field_address: address,
    };
  }
}
