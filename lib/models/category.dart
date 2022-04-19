import '../db/db.dart';

const String tableCategory = 'category';

class CategoryFields {
  static final List<String> values = [
    // all fields
    id, name, type
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String type = 'type';
}

class Category {
  final int? id;
  final String name;
  final String type;

  Category({this.id, required this.name, required this.type});

  // Copy method...
  // for use when creating the table

  Category copy({
    int? id,
    String? name,
    String? type,
  }) =>
      Category(
          id: id ?? this.id, name: name ?? this.name, type: type ?? this.type);

  // fromJson Method
  // for reading the objects

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        name: json[CategoryFields.name] as String,
        type: json[CategoryFields.type] as String,
      );

  // toJson Map
  // use in creating and updating a record
  //
  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.name: name,
        CategoryFields.type: type,
      };

  // create Method

  static Future<Category> create(Category category) async {
    final db = await MainDatabase.instance.database;
    final id = await db.insert(tableCategory, category.toJson());
    return category.copy(id: id);
  }

  // read method
  static Future<Category> readCategory(int id) async {
    final db = await MainDatabase.instance.database;

    final maps = await db.query(
      tableCategory,
      columns: CategoryFields.values,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // readall method
  static Future<List<Category>> readAllCategories() async {
    final db = await MainDatabase.instance.database;

    // final orderBy = '${CategoryFields.name} ASC';
    // final result = await db.query(tableCategory, orderBy: orderBy);
    final result = await db.query(tableCategory);

    return result.map((json) => Category.fromJson(json)).toList();
  }

  // update method
  static Future<int> update(Category category) async {
    final db = await MainDatabase.instance.database;

    return db.update(
      tableCategory,
      category.toJson(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  // delete method
  static Future<int> delete(int id) async {
    final db = await MainDatabase.instance.database;

    return await db.delete(
      tableCategory,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
  }
}
