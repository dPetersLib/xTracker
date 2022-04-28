// import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/account.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/transaction.dart';
import '../models/txtype.dart';
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
INSERT INTO $tableUser (
  ${UserFields.firstName},
  ${UserFields.lastName},
  ${UserFields.phoneNo},
  ${UserFields.isWorking},
  ${UserFields.email},
  ${UserFields.pin}
  )
VALUES (
  'Peter',
  'Augustine',
  '08081721540',
  1,
  'augustinepeter25@hotmail.com',
  2005
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
INSERT INTO $tableCategory (
  ${CategoryFields.name},
  ${CategoryFields.type}
  )
VALUES ('Transportation', 'Expenses')
''');

    await db.execute('''
CREATE TABLE $tableTxType (
  ${TxTypeFields.id} $idType,
  ${TxTypeFields.type} $textType,
  ${TxTypeFields.color} $textType
  )
''');
    await db.execute('''
INSERT INTO $tableTxType (
  ${TxTypeFields.type},
  ${TxTypeFields.color}
  )
VALUES ('Income', 'green')
''');
    await db.execute('''
INSERT INTO $tableTxType (
  ${TxTypeFields.type},
  ${TxTypeFields.color}
  )
VALUES ('Expense', 'red')
''');

    await db.execute('''
CREATE TABLE $tableCurrency (
  ${CurrencyFields.id} $idType,
  ${CurrencyFields.name} $textType,
  ${CurrencyFields.description} $textType
  )
''');
    await db.execute('''
INSERT INTO $tableCurrency (
  ${CurrencyFields.name},
  ${CurrencyFields.description}
  )
VALUES (
  'NGN',
  'Nigerian Naira'
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

    await db.execute('''
INSERT INTO $tableAccount (
  ${AccountFields.userId},
  ${AccountFields.description},
  ${AccountFields.initialAmount},
  ${AccountFields.currencyId},
  ${AccountFields.balance}
  )
VALUES (
  1,
  'Cash',
  0,
  1,
  0
  )
''');

    await db.execute('''
CREATE TABLE $tableTransaction (
  ${TransactionFields.id} $idType,
  ${TransactionFields.description} $textType,
  ${TransactionFields.amount} $integerType,
  ${TransactionFields.typeId} $integerType,
  ${TransactionFields.categoryId} $integerType,
  ${TransactionFields.date} $textType,
  ${TransactionFields.accountId} $integerType,
  ${TransactionFields.currencyId} $integerType,
  FOREIGN KEY (${TransactionFields.typeId}) REFERENCES $tableTxType(${TxTypeFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $tableCategory(${CategoryFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $tableAccount(${AccountFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (${TransactionFields.currencyId}) REFERENCES $tableCurrency(${CurrencyFields.id}) ON DELETE NO ACTION ON UPDATE NO ACTION
)''');

    await db.execute('''
INSERT INTO $tableTransaction (
  ${TransactionFields.description},
  ${TransactionFields.amount},
  ${TransactionFields.typeId},
  ${TransactionFields.categoryId},
  ${TransactionFields.date},
  ${TransactionFields.accountId},
  ${TransactionFields.currencyId}
  )
  VALUES (
    'Food',
    500,
    2,
    1,
    '${DateTime(2022, 4, 27, 5, 2)}',
    1,
    1
  )
  ''');
    await db.execute('''
INSERT INTO $tableTransaction (
  ${TransactionFields.description},
  ${TransactionFields.amount},
  ${TransactionFields.typeId},
  ${TransactionFields.categoryId},
  ${TransactionFields.date},
  ${TransactionFields.accountId},
  ${TransactionFields.currencyId}
  )
  VALUES (
    'Salary',
    1000,
    1,
    1,
    '${DateTime(2022, 4, 25, 5, 2)}',
    1,
    1
  )
  ''');
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
