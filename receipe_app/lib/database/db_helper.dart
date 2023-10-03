import 'dart:async';

import 'package:receipe_app/model/meal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  DBHelper._createInstance();
  static final DBHelper _instance = DBHelper._createInstance();
  factory DBHelper() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    _db = await setDB();
    return _db ?? _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "mealsDb");
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  Future<void> _onCreate(Database db, int version) async {
    var sql =
        "CREATE TABLE favorite(id INTEGER PRIMARY KEY, idMeal TEXT,  strMeal TEXT, strInstructions TEXT, strMealThumb TEXT, strCategory TEXT)";
    await db.execute(sql);
  }

  Future<int> insert(Meal meal) async {
    var dbClient = await db;
    int res = await dbClient!.insert("favorite", meal.toJson());
    return res;
  }

  Future<List<Meal>> gets(String category) async {
    var dbClient = await db;
    var sql = "SELECT * FROM favorite WHERE strCategory=? ORDER BY idMeal DESC";
    List<Map> list = await dbClient!.rawQuery(sql, [category]);
    List<Meal> favorites = [];
    for (int i = 0; i < list.length; i++) {
      Meal favorite = Meal(
        idMeal: list[i]["idMeal"],
        strMeal: list[i]["strMeal"],
        strInstructions: list[i]["strInstructions"],
        strMealThumb: list[i]["strMealThumb"],
        strCategory: list[i]["strCategory"],
      );
      favorite.setFavoriteId(list[i]['idMeal']);
      favorites.add(favorite);
    }
    return favorites;
  }

  Future<Meal> get(String idMeal) async {
    var dbClient = await db;
    var sql = "SELECT * FROM favorite WHERE idMeal=? ORDER BY idMeal DESC";
    List<Map> list = await dbClient!.rawQuery(sql, [idMeal]);
    if (list.isNotEmpty) {
      return Meal.fromJson(list.first);
    } else {
      throw Exception('ID $idMeal not found');
    }
  }

  Future<int> delete(Meal meals) async {
    var dbClient = await db;
    var sql = "DELETE FROM favorite WHERE idMeal = ?";
    int res = await dbClient!.rawDelete(sql, [meals.idMeal]);
    print("Favorite data deleted");
    return res;
  }

  Future<bool> isFavorite(String? idMeals) async {
    var dbClient = await db;
    var sql = "SELECT * FROM favorite WHERE idMeal = ?";
    var res = await dbClient!.rawQuery(sql, [idMeals]);

    return res.isNotEmpty;
  }
}
