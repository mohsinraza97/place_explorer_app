import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/entities/place.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/helpers/logger.dart';

class DatabaseClient {
  DatabaseClient._internal();

  static final DatabaseClient _instance = DatabaseClient._internal();

  static DatabaseClient get instance => _instance;

  Database? _database;

  Future<List<Map<String, dynamic>>?> fetch(
    String table, {
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    try {
      final db = await _initDatabase();
      final values = await db.query(
        table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
      );
      Logger.debug(
        'DatabaseClient',
        'fetch',
        'Data: ${values.toString()}, Table: $table, Columns: ${columns.toString()}, Where: $where, Args: ${whereArgs.toString()}, OrderBy: $orderBy',
      );
      return values;
    } on Exception catch (e) {
      Logger.error('DatabaseClient', 'fetch', e);
      return null;
    }
  }

  Future<int?> insert(String table, Map<String, dynamic> values) async {
    try {
      final db = await _initDatabase();
      final id = await db.insert(
        table,
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Logger.debug(
        'DatabaseClient',
        'insert',
        'ID: $id, Table: $table, Values: ${values.toString()}',
      );
      return id;
    } on Exception catch (e) {
      Logger.error('DatabaseClient', 'insert', e);
      return null;
    }
  }

  Future<int?> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await _initDatabase();
      final count = await db.update(
        table,
        values,
        where: where,
        whereArgs: whereArgs,
      );
      Logger.debug(
        'DatabaseClient',
        'update',
        'Count: $count, Table: $table, Values: ${values.toString()}, Where: $where, Args: ${whereArgs.toString()}',
      );
      return count;
    } on Exception catch (e) {
      Logger.error('DatabaseClient', 'update', e);
      return null;
    }
  }

  Future<int?> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await _initDatabase();
      final count = await db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
      Logger.debug(
        'DatabaseClient',
        'delete',
        'Count: $count, Table: $table, Where: $where, Args: ${whereArgs.toString()}',
      );
      return count;
    } on Exception catch (e) {
      Logger.error('DatabaseClient', 'delete', e);
      return null;
    }
  }

  Future<String> getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return join(appDir.path, AppConstants.db_name);
  }

  Future<Database> _initDatabase() async {
    final isOpened = _database?.isOpen ?? false;
    if (!isOpened) {
      _database = await openDatabase(
        await getDatabasePath(),
        version: AppConstants.db_version,
        onConfigure: (db) async {
          // Db initializations
          Logger.debug(
            'DatabaseClient',
            'init',
            'onConfigure',
          );
          return await _configureDatabase(db);
        },
        onCreate: (db, version) async {
          // Fresh database creation
          Logger.debug(
            'DatabaseClient',
            'init',
            'onCreate: (Version: $version)',
          );
          return await _createDatabase(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Schema migration in existing database
          Logger.debug(
            'DatabaseClient',
            'init',
            'onUpgrade: (OldVersion: $oldVersion, NewVersion: $newVersion)',
          );
          return await _upgradeDatabase(db);
        },
      );
    }
    return _database!;
  }

  Future<void> _configureDatabase(Database? db) async {
    try {
      await db?.execute('PRAGMA foreign_keys = ON');
    } on Exception catch (e) {
      Logger.error('DatabaseClient', '_configureDatabase', e);
    }
  }

  Future<void> _createDatabase(Database? db) async {
    try {
      await db?.execute(
        'CREATE TABLE IF NOT EXISTS ${PlaceLocation.table_name} ('
        '${PlaceLocation.field_id} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${PlaceLocation.field_latitude} REAL NOT NULL,'
        '${PlaceLocation.field_longitude} REAL NOT NULL,'
        '${PlaceLocation.field_address} TEXT'
        ')',
      );

      await db?.execute(
        'CREATE TABLE IF NOT EXISTS ${Place.table_name} ('
        '${Place.field_id} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${Place.field_title} TEXT NOT NULL,'
        '${Place.field_image} TEXT,'
        '${Place.field_location_id} INTEGER,'
        'FOREIGN KEY(${Place.field_location_id}) REFERENCES ${PlaceLocation.table_name}(${PlaceLocation.field_id})'
        ')',
      );
    } on Exception catch (e) {
      Logger.error('DatabaseClient', '_createDatabase', e);
    }
  }

  Future<void> _upgradeDatabase(Database? db) async {}

  Future<void> _closeDatabase() async {
    await _database?.close();
  }
}
