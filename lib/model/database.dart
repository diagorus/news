import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "NewsDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE SearchHistory (query TEXT PRIMARY KEY)");
    });
  }

  insertSearchHistory(SearchHistory searchHistory) async {
    final db = await database;
    var res = await db.rawInsert(
      "INSERT Into SearchHistory (timestamp,query) VALUES (${searchHistory.timestamp},${searchHistory.query})",
    );
    return res;
  }

  updateSearchHistory(SearchHistory searchHistory) async {
    final db = await database;
    var res = await db.rawUpdate(
      "UPDATE SearchHistory SET timestamp='${searchHistory.timestamp}' WHERE query=${searchHistory.query}",
    );
    return res;
  }

  getAllSearchHistoryOrdered(SearchHistory searchHistory) async {
    final db = await database;
    var res = await db.rawQuery(
      "SELECT * FROM SearchHistory ORDER BY timestamp DESC",
    );
    List<SearchHistory> list = res.isNotEmpty
        ? res.toList().map((c) => SearchHistory.fromMap(c))
        : null;
    return list;
  }

  insertOrUpdateSearchHistory(SearchHistory searchHistory) async {
    if (await updateSearchHistory(searchHistory) == 0) {
      await insertSearchHistory(searchHistory);
    }
  }
}
