import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'itemModel.dart';

const String kDatabaseName = 'todolist.db';
const String kTableName = 'list';
const String kColumnId = 'id';
const String kColumnName = 'name';
const String kColumnChecked = 'checked';

class MyDatabase {
  // Cria a propriedade _instance com MyDatabase
  static MyDatabase _instance = new MyDatabase._internal();

  // Informa que a classe possui um contructor factory
  MyDatabase._internal();

  // Retorna a instancia gerada internamente
  factory MyDatabase() => _instance;

  Database _db;

  Future<Database> get db async {
    if (this._db != null) {
      return _db;
    }
    return await init();
  }

  Future<Database> init() async {
    var pathDatabase = await getDatabasesPath();
    var path = join(pathDatabase, kDatabaseName);
    return await openDatabase(path, version: 1, onCreate: this._createDatabase);
  }

  Future<Item> addItem(Item item) async {
    Database db = await this.db;
    db.insert(kTableName, item.toMap());
    final listItem = await db.rawQuery('SELECT * FROM $kTableName');
    return new Item.fromJson(listItem.last);
  }

  Future<List> getItems() async {
    Database db = await this.db;
    List<Map> response = await db.rawQuery('SELECT * FROM $kTableName');
    return response.map((item) => Item.fromJson(item)).toList();
  }

  Future<int> removeItem(id) async {
    Database db = await this.db;
    return await db
        .delete(kTableName, where: "$kColumnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(Item item) async {
    Database db = await this.db;
    return await db.update(kTableName, item.toMap(),
        where: "$kColumnId = ?", whereArgs: [item.id]);
  }

  void _createDatabase(Database db, int newerVersion) async {
    await db.execute(
        'CREATE TABLE $kTableName( $kColumnId INTEGER PRIMARY KEY, $kColumnName TEXT, $kColumnChecked INTEGER)');
  }
}
