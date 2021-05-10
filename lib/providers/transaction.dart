import 'package:flutter/foundation.dart';

class Transaction {
  final String title, id;
  final double amount;
  final DateTime date;
  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
}
