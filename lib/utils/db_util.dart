import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBUtil {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(join(dbPath, 'places.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBUtil.database();
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object?>>> getData(String table) async {
    final db = await DBUtil.database();
    return db.query(table);
  }

  static Future<int> deleteTable(String table) async {
    final db = await DBUtil.database();
    return db.delete(table);
  }

  static Future<void> deleteById(String table, String id) async {
    final db = await DBUtil.database();
    db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
