import '../db/db.dart';

const tableAccount = 'account';

class AccountFields {
  static final List<String> values = [
    id,
    userId,
    description,
    initialAmount,
    currencyId,
    balance
  ];

  static const String id = '_id';
  static const String userId = 'userId';
  static const String description = 'description';
  static const String initialAmount = 'initialAmount';
  static const String currencyId = 'currencyId';
  static const String balance = 'balance';
}

class Account {
  final int? id;
  final int userId;
  final String description;
  final double? initialAmount;
  final int currencyId;
  final double balance;

  // class constructor

  Account(
      {this.id,
      required this.userId,
      required this.description,
      required this.initialAmount,
      required this.currencyId,
      required this.balance});

// Copy method

  Account copy(
          {int? id,
          int? userId,
          String? description,
          double? initialAmount,
          int? currencyId,
          double? balance}) =>
      Account(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          description: description ?? this.description,
          initialAmount: initialAmount ?? this.initialAmount,
          currencyId: currencyId ?? this.currencyId,
          balance: balance ?? this.balance);

  // from json method

  static Account fromJson(Map<String, Object?> json) => Account(
      id: json[AccountFields.id] as int,
      userId: json[AccountFields.userId] as int,
      description: json[AccountFields.description] as String,
      initialAmount: json[AccountFields.initialAmount] as double,
      currencyId: json[AccountFields.currencyId] as int,
      balance: json[AccountFields.balance] as double);

  // toJson Map
  // use in creating and updating a record
  //
  Map<String, Object?> toJson() => {
        AccountFields.id: id,
        AccountFields.userId: userId,
        AccountFields.description: description,
        AccountFields.initialAmount: initialAmount,
        AccountFields.currencyId: currencyId,
        AccountFields.balance: balance
      };

  static Future<Account> create(Account account) async {
    final db = await MainDatabase.instance.database;

    final id = await db.insert(tableAccount, account.toJson());

    return account.copy(id: id);
  }

  static Future<Account> readAccount(int id) async {
    final db = await MainDatabase.instance.database;

    final maps = await db.query(
      tableAccount,
      columns: AccountFields.values,
      where: '${AccountFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Account.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<Account>> readAllAccount() async {
    final db = await MainDatabase.instance.database;
    const orderBy = '${AccountFields.description} ASC';
    final result = await db.query(tableAccount, orderBy: orderBy);

    return result.map((json) => Account.fromJson(json)).toList();
  }

  static Future<int> update(Account account) async {
    final db = await MainDatabase.instance.database;

    return await db.update(tableAccount, account.toJson(),
        where: '${AccountFields.id} = ?', whereArgs: [account.id]);
  }

  static Future<int> delete(Account account) async {
    final db = await MainDatabase.instance.database;

    return await db.delete(tableAccount,
        where: '${AccountFields.id} = ?', whereArgs: [account.id]);
  }
}
