import 'package:flutter/material.dart';
import '../services/local/database_service.dart';
import '../app_locator.dart';
import '../services/base_service.dart';

// In such implementation the view models don't actually have to know anything
// about the data source (network, storage, database)

// A concrete implementation to service contract
class BaseRepository implements BaseService {
  @protected
  final databaseService = locator<DatabaseService>();
}
