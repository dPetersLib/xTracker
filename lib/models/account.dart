final tableAccount = 'account';

class AccountFields {
  static final List
  static final String id = '_id';
  static final String studentId = 'studentId';
  static final String description = 'description';
  static final String initialAmount = 'initialAmount';
  static final String currencyId = 'currencyId';
  static final String balance = 'balance';
}

class Account {
  final int? id;
  final int studentId;
  final String description;
  final double? initialAmount;
  final int currencyId;
  final double balance;

  Account({
    this.id,
    required this.studentId,
    required this.description,
    required this.initialAmount,
    required this.currencyId,
    required this.balance
      });
}
