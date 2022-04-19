// import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/account.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/transaction.dart';
import '../models/user.dart';

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

    return await openDatabase(path,
        version: 1, onConfigure: _configureDB, onCreate: _createDB);
  }

  Future _configureDB(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future _createDB(Database db, int version) async {
    // defining our datatypes
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableUser(
  ${UserFields.id} $idType,
  ${UserFields.firstName} $textType,
  ${UserFields.lastName} $textType,
  ${UserFields.phoneNo} $textType,
  ${UserFields.isWorking} $boolType,
  ${UserFields.email} $textType,
  ${UserFields.pin} $integerType
  )
''');

    await db.execute('''
CREATE TABLE $tableCategory (
  ${CategoryFields.id} $idType,
  ${CategoryFields.name} $textType,
  ${CategoryFields.type} $textType
  )
''');

    await db.execute('''
CREATE TABLE $tableAccount (
  ${AccountFields.id} $idType,
  ${AccountFields.userId} $integerType,
  ${AccountFields.description} $textType,
  ${AccountFields.initialAmount} $integerType,
  ${AccountFields.currencyId} $integerType,
  ${AccountFields.balance} $integerType,
  FOREIGN KEY (${AccountFields.currencyId}) REFERENCES $tableCurrency(${CurrencyFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (${AccountFields.userId}) REFERENCES $tableUser(${UserFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION
  )
''');

//     await db.execute('''
// CREATE TABLE $tableTransaction (
//   ${TransactionFields.id} $idType,
//   ${TransactionFields.description} $textType,
//   ${TransactionFields.amount} $integerType,
//   ${TransactionFields.categoryId} $integerType,
//   ${TransactionFields.date} $Type,
//   ${TransactionFields.accountId} $idType,
//   ${TransactionFields.currencyId} $integerType,
//   FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $tableCategory(${CategoryFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
//   FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $tableAccount(${AccountFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
//   FOREIGN KEY (${TransactionFields.currencyId}) REFERENCES $tableCurrency(${CurrencyFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
// )''');
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
