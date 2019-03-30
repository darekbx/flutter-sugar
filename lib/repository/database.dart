import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// https://github.com/Rahiche/sqlite_demo/blob/master/lib/Database.dart
class DatabaseProvider {
  DatabaseProvider._();

  static final String dbName = "sugar.db";
  static final int dbVersion = 1;
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initializeDatabase();
    return _database;
  }

  initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path,
        version: dbVersion,
        onOpen: (db) {},
        onCreate: (Database db, int version) => _createModels(db));
  }

  _createModels(Database db) async {
    await db.execute("");
  }
}
