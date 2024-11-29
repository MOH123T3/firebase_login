import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';

class LocalDatabase {
  @required
  final int? id;
  @required
  final String? title;
  @required
  final String? description;
  @required
  final int? timestamp;

  LocalDatabase({this.id, this.title, this.description, this.timestamp});

  LocalDatabase.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        timestamp = map['timestamp'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['timestamp'] = timestamp;

    return map;
  }
}

class LocalTableDatabase {
  static final LocalTableDatabase _instance = LocalTableDatabase._();
  static Database? _database;

  LocalTableDatabase._();

  factory LocalTableDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }

    _database = await init();

    return _database!;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'a_database.db');

    var database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE tab_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        timestamp INTEGER)
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> addData(LocalDatabase product) async {
    var client = await db;

    return client.insert('tab_data', product.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<LocalDatabase> fetchData(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('tab_data', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return LocalDatabase.fromDb(maps.first);
    }

    return null!;
  }

  Future<List<LocalDatabase>> fetchAllData() async {
    var client = await db;
    var res = await client.query('tab_data');

    if (res.isNotEmpty) {
      var products =
          res.map((productsMap) => LocalDatabase.fromDb(productsMap)).toList();
      return products;
    }
    return [];
  }

  Future<int> update(LocalDatabase newProduct) async {
    var client = await db;
    return client.update('tab_data', newProduct.toMapForDb(),
        where: 'id = ?',
        whereArgs: [newProduct.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Future<int>> remove(int id) async {
    var client = await db;
    return client.delete('tab_data', where: 'id = ?', whereArgs: [id]);
  }

  Future closeDb() async {
    var client = await db;
    client.delete('tab_data');
  }
}
