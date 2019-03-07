import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'itemModel.dart';

const String kDatabaseName = 'todolist.db';
const String kTableName = 'list';
const String kColumnId = 'id';
const String kColumnName = 'name';
const String kColumnChecked = 'checked';

class MyDatabase {
  static Database db;

  static Future<Database> init() async {
    db = await initDatabase();
    return db;
  }

  static Future<Database> initDatabase() async {
    var pathDatabase = await getDatabasesPath();
    var path = join(pathDatabase, kDatabaseName);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static void _createDatabase(Database db, int newerVersion) async {
    await db.execute(
        'CREATE TABLE $kTableName( $kColumnId INTEGER PRIMARY KEY, $kColumnName TEXT, $kColumnChecked INTEGER)');
  }

  static Future<Item> addItem(Item item) async {
    await init();
    db.insert(kTableName, item.toMap());
    final listItem = await db.rawQuery('SELECT * FROM $kTableName');
    return new Item.fromJson(listItem.last);
  }

  static Future<List> getItems() async {
    await init();
    List<Map<String, dynamic>> response =
        await db.rawQuery('SELECT * FROM $kTableName');
    List<Item> list = [];
    for (Map item in response) {
      list.add(Item.fromJson(item));
    }
    return list;
  }

  static Future<int> removeItem(id) async {
    return await db
        .delete(kTableName, where: "$kColumnId = ?", whereArgs: [id]);
  }

  static Future<int> updateItem(Item item) async {
    return await db.update(kTableName, item.toMap(),
        where: "$kColumnId = ?", whereArgs: [item.id]);
  }
}
