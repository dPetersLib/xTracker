class Transaction {
  // this class is not a widget, so not extending Stateless or Stateful
  
  String id;
  String title;
  double amount;
  DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
}

// const String tableTransaction = 'transaction';

// class TransactionFields {
//   static const String id = '_id';
//   static const String description = 'description';
//   static const String amount = 'amount';
//   static const String date = 'date';
//   static const String categoryId = 'categoryId';
//   static const String accountId = 'accountId';
//   static const String currencyId = 'currencyId';
// }

// class Transaction {
//   final int? id;
//   final String description;
//   final double amount;
//   final DateTime date;
//   final int categoryId;
//   final int accountId;
//   final int currencyId;

//   Transaction({
//     this.id,
//     required this.description,
//     required this.amount,
//     required this.date,
//     required this.categoryId,
//     required this.accountId,
//     required this.currencyId,
//   });
// }
