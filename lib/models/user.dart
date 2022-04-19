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
}
