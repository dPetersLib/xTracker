// import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category.dart';

class MainDatabase {
  static final MainDatabase instance = MainDatabase._init();

  static Database? _database;

  MainDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('xtracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
  // defining our datatypes
  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final textType = 'TEXT NOT NULL';
  final boolType = 'BOOLEAN NOT NULL';
  final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableCategory (
  ${CategoryFields.id} $idType,
  ${CategoryFields.name} $textType,
  ${CategoryFields.type} $textType
  )''');
  }

  Future closeDB() async {
    final db = await instance.database;

    db.close();
  }
}
// class SQLiteDbProvider {
//   SQLiteDbProvider._();

//   static final SQLiteDbProvider db = SQLiteDbProvider._();

//   static Database _database;
// }

// Future<Database> get database async {
//   if (_database != null) {
//     return _database;
//   }
//   _database = await initDB();
//   return _database;
// }

// initDB() async {
//   Directory documentsDirectory = await getApplicationDocumentsDirectory();
//   String path = join(documentsDirectory.path, "app.db");
//   return await openDatabase(path,
//       version: 1, onOpen: (db) {}, onCreate: _createDB);
// }

// Future _createDB(Database db, int version) async {
//   // defining our datatypes
//   final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//   final textType = 'TEXT NOT NULL';
//   final boolType = 'BOOLEAN NOT NULL';
//   final integerType = 'INTEGER NOT NULL';

//     await db.execute('''
// CREATE TABLE $tableCategory (
//   ${CategoryFields.id} $idType,
//   ${CategoryFields.name} $textType,
//   ${CategoryFields.type} $textType, 
// );
// ''');

// }
