import 'package:flutter/cupertino.dart';

class Offer {
  final String id, rewardPoint, voucherCode;
  final double amount;
  Offer(
      {@required this.id,
      @required this.rewardPoint,
      @required this.voucherCode,
      @required this.amount});
}
