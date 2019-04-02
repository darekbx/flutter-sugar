import 'dart:async';
import 'package:collection/collection.dart';

import 'package:flutter_sugar/repository/local/database.dart';
import 'package:flutter_sugar/model/entry.dart';

class Repository {
  
  Future<Map<String, List<Entry>>> list() async {
    var entries = await DatabaseProvider.instance.list();
    var entriesMap = groupBy<Entry, String>(entries, (entry) => entry.dateTime());
    return Map.from(entriesMap);
  }

  Future<int> add(Entry entry) async =>
      await DatabaseProvider.instance.add(entry);
  Future<int> delete(int id) async =>
      await DatabaseProvider.instance.delete(id);
}