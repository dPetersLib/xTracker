import '../db/db.dart';

// class Transaction {
//   // this class is not a widget, so not extending Stateless or Stateful

//   String id;
//   String title;
//   int amount;
//   DateTime date;

//   Transaction(
//       {required this.id,
//       required this.title,
//       required this.amount,
//       required this.date});
// }

const String tableTransaction = 'trans';

class TransactionFields {
  static final List<String> values = [
    // all fields
    id, description, amount, date, typeId, categoryId, accountId, currencyId
  ];
  static const String id = '_id';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String categoryId = 'categoryId';
  static const String typeId = 'typeId';
  static const String accountId = 'accountId';
  static const String currencyId = 'currencyId';
}

class Transaction {
  final int? id;
  final String description;
  final int amount;
  final DateTime date;
  final int typeId;
  final int categoryId;
  final int accountId;
  final int currencyId;

  Transaction({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.typeId,
    required this.categoryId,
    required this.accountId,
    required this.currencyId,
  });

  Transaction copy({
    int? id,
    String? description,
    int? amount,
    DateTime? date,
    int? typeId,
    int? categoryId,
    int? accountId,
    int? currencyId,
  }) =>
      Transaction(
          id: id ?? this.id,
          description: description ?? this.description,
          amount: amount ?? this.amount,
          date: date ?? this.date,
          typeId: typeId ?? this.typeId,
          categoryId: categoryId ?? this.categoryId,
          accountId: accountId ?? this.accountId,
          currencyId: currencyId ?? this.currencyId);

  static Transaction fromJson(Map<String, Object?> json) => Transaction(
      id: json[TransactionFields.id] as int,
      description: json[TransactionFields.description] as String,
      amount: json[TransactionFields.amount] as int,
      date: DateTime.parse(json[TransactionFields.date] as String),
      typeId: json[TransactionFields.typeId] as int,
      categoryId: json[TransactionFields.categoryId] as int,
      accountId: json[TransactionFields.accountId] as int,
      currencyId: json[TransactionFields.currencyId] as int);

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.description: description,
        TransactionFields.amount: amount,
        TransactionFields.date: date.toIso8601String(),
        TransactionFields.typeId: typeId,
        TransactionFields.categoryId: categoryId,
        TransactionFields.accountId: accountId,
        TransactionFields.currencyId: currencyId
      };

  static Future<Transaction> create(Transaction transaction) async {
    final db = await MainDatabase.instance.database;
    final id = await db.insert(tableTransaction, transaction.toJson());
    return transaction.copy(id: id);
  }

  static Future<double> getTotalTx() async {
    return 0;
  }

  static Future<Transaction> readTx(int id) async {
    final db = await MainDatabase.instance.database;

    final maps = await db.query(
      tableTransaction,
      columns: TransactionFields.values,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Transaction.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<Transaction>> readAllTx() async {
    final db = await MainDatabase.instance.database;

    const orderBy = '${TransactionFields.date} DESC';
    final result = await db.query(tableTransaction, orderBy: orderBy);

    return result.map((json) => Transaction.fromJson(json)).toList();
  }

  static Future<int> update(Transaction transaction) async {
    final db = await MainDatabase.instance.database;

    return db.update(
      tableTransaction,
      transaction.toJson(),
      where: '${TransactionFields.id} = ?',
      whereArgs: [transaction.id],
    );
  }

  static Future<int> delete(int? id) async {
    final db = await MainDatabase.instance.database;

    return await db.delete(
      tableTransaction,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );
  }

//   static Future<int> getBalance() async {}

//   static Future<int> getIncomeTotal() async {
//     final db = await MainDatabase.instance.database;
//     final result = await db.query(tableTransaction,
//         where: '${TransactionFields.typeId} = ?', whereArgs: [1]);
//     final List income =
//         result.map((json) => Transaction.fromJson(json)).toList();
//     int total = 0;
//     for (var tx in income) {
//       total += tx.amount;
//     }
//     for (var i = 0; i < income.length; i++) {
//       total += income[i].amount
//     }
//   }
// }
}
