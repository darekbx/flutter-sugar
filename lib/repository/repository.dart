import 'dart:async';
import 'package:collection/collection.dart';

import 'package:flutter_sugar/repository/local/database.dart';
import 'package:flutter_sugar/model/entry.dart';

class Repository {
  
  Future<List<Entry>> distinctList() async {
    List<Entry> entries = await DatabaseProvider.instance.list();
    return entries;
  }

  Future<Map<String, List<Entry>>> list() async {
    List<Entry> entries = await DatabaseProvider.instance.list();
    if (entries.length == 0) {
      return Map<String, List<Entry>>();
    }
    var entriesMap = groupBy<Entry, String>(entries, (entry) => entry.dateTime());
    return Map.from(entriesMap);
  }

  Future<List<double>> chartValues() async {
    return await DatabaseProvider.instance.daySummary();
  }

  Future<int> add(Entry entry) async =>
      await DatabaseProvider.instance.add(entry);
  Future<int> delete(int id) async =>
      await DatabaseProvider.instance.delete(id);
}
