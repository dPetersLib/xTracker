import '../db/db.dart';

const String tableTxType = 'txtype';

class TxTypeFields {
  static final List<String> values = [
    // all fields
    id, type
  ];

  static const String id = '_id';
  static const String type = '_type';
  static const String color = '_color';  
}

class TxType {
  final int? id;
  final String type;
  final String color;

  TxType({this.id, required this.type, required this.color});

  // Copy method...
  // for use when creating the table

  TxType copy({
    int? id,
    String? type,
    String? color,
  }) =>
      TxType(
          id: id ?? this.id, type: type ?? this.type, color: color ?? this.color);

  // fromJson Method
  // for reading the objects

  static TxType fromJson(Map<String, Object?> json) => TxType(
        id: json[TxTypeFields.id] as int?,
        type: json[TxTypeFields.type] as String,
        color: json[TxTypeFields.color] as String,
      );

  // toJson Map
  // use in creating and updating a record
  //
  Map<String, Object?> toJson() => {
        TxTypeFields.id: id,
        TxTypeFields.type: type,
        TxTypeFields.color: color,
      };

  // create Method

  static Future<TxType> create(TxType txtype) async {
    final db = await MainDatabase.instance.database;
    final id = await db.insert(tableTxType, txtype.toJson());
    return txtype.copy(id: id);
  }

  // read method
  static Future<TxType> readTxType(int id) async {
    final db = await MainDatabase.instance.database;

    final maps = await db.query(
      tableTxType,
      columns: TxTypeFields.values,
      where: '${TxTypeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TxType.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // readall method
  static Future<List<TxType>> readAllTypes() async {
    final db = await MainDatabase.instance.database;

    // final orderBy = '${TxTypeFields.name} ASC';
    // final result = await db.query(tableTxType, orderBy: orderBy);
    final result = await db.query(tableTxType);

    return result.map((json) => TxType.fromJson(json)).toList();
  }

  // update method
  static Future<int> update(TxType txtype) async {
    final db = await MainDatabase.instance.database;

    return db.update(
      tableTxType,
      txtype.toJson(),
      where: '${TxTypeFields.id} = ?',
      whereArgs: [txtype.id],
    );
  }

  // delete method
  static Future<int> delete(int id) async {
    final db = await MainDatabase.instance.database;

    return await db.delete(
      tableTxType,
      where: '${TxTypeFields.id} = ?',
      whereArgs: [id],
    );
  }
}
