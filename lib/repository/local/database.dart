import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_sugar/model/entry.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final String dbName = "sugar.db";
  static final int dbVersion = 1;
  static final DatabaseProvider instance = DatabaseProvider._();

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
    await db.execute("""
    CREATE TABLE entries (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      sugar REAL, 
      timestamp INTEGER
    )""");
  }

  Future<int> add(Entry entry) async =>
      await (await database).insert("entries", entry.toMap());

  Future<List<double>> daySummary() async {
    var query = """
      SELECT 
        SUM(sugar) AS sum, 
        strftime('%Y-%m-%d',DATETIME(timestamp/1000, 'unixepoch'))
      FROM entries 
      GROUP BY strftime('%Y-%m-%d',DATETIME(timestamp/1000, 'unixepoch'))""";
    var cursor = await (await database).rawQuery(query);
    return cursor.isNotEmpty
        ? cursor.map((row) => row['sum'] as double).toList()
        : List<double>();
  }

  list() async {
    var cursor = await (await database).query("entries", orderBy: "timestamp DESC");
    return _cursorToList(cursor);
  }

  distinctList() async {
    var cursor = await (await database).rawQuery("SELECT id, name, sugar, timestamp FROM entries GROUP BY name");
    return _cursorToList(cursor);
  }

  Future<int> delete(int id) async => await (await database)
      .delete("entries", where: "id = ?", whereArgs: [id]);

  List<Entry> _cursorToList(List<Map<String, dynamic>> cursor) {
    return cursor.isNotEmpty
        ? cursor.map((row) => Entry.fromMap(row)).toList()
        : List<Entry>();
  }
}