import '../db/db.dart';

const String tableCurrency = 'Currency';

class CurrencyFields {
  static final List<String> values = [
    // all fields
    id, name, description
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String description = 'description';
}

class Currency {
  final int? id;
  final String name;
  final String description;

  Currency({this.id, required this.name, required this.description});

  // Copy method...
  // for use when creating the table

  Currency copy({
    int? id,
    String? name,
    String? description,
  }) =>
      Currency(
          id: id ?? this.id, name: name ?? this.name, description: description ?? this.description);

  // fromJson Method
  // for reading the objects

  static Currency fromJson(Map<String, Object?> json) => Currency(
        id: json[CurrencyFields.id] as int?,
        name: json[CurrencyFields.name] as String,
        description: json[CurrencyFields.description] as String,
      );

  // toJson Map
  // use in creating and updating a record
  //
  Map<String, Object?> toJson() => {
        CurrencyFields.id: id,
        CurrencyFields.name: name,
        CurrencyFields.description: description,
      };

  // create Method

  static Future<Currency> create(Currency currency) async {
    final db = await MainDatabase.instance.database;
    final id = await db.insert(tableCurrency, currency.toJson());
    return currency.copy(id: id);
  }

  // read method
  static Future<Currency> readCurrency(int id) async {
    final db = await MainDatabase.instance.database;

    final maps = await db.query(
      tableCurrency,
      columns: CurrencyFields.values,
      where: '${CurrencyFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Currency.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // readall method
  static Future<List<Currency>> readAllCategories() async {
    final db = await MainDatabase.instance.database;

    final orderBy = '${CurrencyFields.name} ASC';
    final result = await db.query(tableCurrency, orderBy: orderBy);

    return result.map((json) => Currency.fromJson(json)).toList();
  }

  // update method
  static Future<int> update(Currency currency) async {
    final db = await MainDatabase.instance.database;

    return db.update(
      tableCurrency,
      currency.toJson(),
      where: '${CurrencyFields.id} = ?',
      whereArgs: [currency.id],
    );
  }

  // delete method
  static Future<int> delete(int id) async {
    final db = await MainDatabase.instance.database;

    return await db.delete(
      tableCurrency,
      where: '${CurrencyFields.id} = ?',
      whereArgs: [id],
    );
  }
}
