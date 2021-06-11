import 'package:flutter/cupertino.dart';

class Offer {
  final String id, imageUrl, voucherCode;
  final double amount;
  Offer(
      {@required this.id,
      @required this.imageUrl,
      @required this.voucherCode,
      @required this.amount});
}
