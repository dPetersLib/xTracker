import '../db/db.dart';

const tableUser = 'user';

class UserFields {
  static final List<String> values = [
    id,
    firstName,
    lastName,
    phoneNo,
    isWorking,
    email,
    pin
  ];

  static const String id = '_id';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String phoneNo = 'phoneNo';
  static const String isWorking = 'isworking';
  static const String email = 'email';
  static const String pin = 'pin';
}

class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNo;
  final bool isWorking;
  final String? email;
  final int pin;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.isWorking,
    required this.email,
    required this.pin,
  });

  User copy(
          {int? id,
          String? firstName,
          String? lastName,
          String? phoneNo,
          bool? isWorking,
          String? email,
          int? pin}) =>
      User(
          id: id ?? this.id,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          phoneNo: phoneNo ?? this.phoneNo,
          isWorking: isWorking ?? this.isWorking,
          email: email ?? this.email,
          pin: pin ?? this.pin);

  static User fromJson(Map<String, Object?> json) => User(
      id: json[UserFields.id] as int?,
      firstName: json[UserFields.firstName] as String,
      lastName: json[UserFields.lastName] as String,
      phoneNo: json[UserFields.phoneNo] as String,
      isWorking: json[UserFields.isWorking] as bool,
      email: json[UserFields.email] as String,
      pin: json[UserFields.pin] as int);

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName,
        UserFields.phoneNo: phoneNo,
        UserFields.isWorking: isWorking,
        UserFields.email: email,
        UserFields.pin: pin
      };

  static Future<User> create(User user) async {
    final db = await MainDatabase.instance.database;
    final id = await db.insert(tableUser, user.toJson());
    return user.copy(id: id);
  }

  // read method
  static Future<User> readUser(int id) async {
    final db = await MainDatabase.instance.database;

    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<User>> readAllUsers() async {
    final db = await MainDatabase.instance.database;

    const orderBy = '${UserFields.firstName} ASC';
    final result = await db.query(tableUser, orderBy: orderBy);

    return result.map((json) => User.fromJson(json)).toList();
  }

  // update method
  static Future<int> update(User user) async {
    final db = await MainDatabase.instance.database;

    return db.update(
      tableUser,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  // delete method
  static Future<int> delete(int id) async {
    final db = await MainDatabase.instance.database;

    return await db.delete(
      tableUser,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }
}
