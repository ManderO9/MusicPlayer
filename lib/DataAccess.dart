import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Models/SongModel.dart';

class DataAccess {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, "songs.db"), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "create table songs(path text primary key,name text, isFavorite integer)");
    });
  }

  static Future<List<SongModel>> GetFavories() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> result = await db.query("songs");
    return result.map((e) => SongModel.fromMap(e)).toList();
  }

  static Future<void> AddFavorie(SongModel song) async {
    final Database db = await initializeDB();
    await db.insert("songs", song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> RemoveFavorie(SongModel song) async {
    final Database db = await initializeDB();
    await db.delete("songs", where: "path = ?", whereArgs: [song.path]);
  }
}
