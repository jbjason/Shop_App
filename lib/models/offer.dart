import 'package:flutter/cupertino.dart';

class Offer {
  final String id, voucherCode;
  final double amount, rewardPoint;
  Offer(
      {@required this.id,
      @required this.rewardPoint,
      @required this.voucherCode,
      @required this.amount});
}

class OffersImagesList {
  final String id, imageUrl, offerName;
  OffersImagesList({
    @required this.id,
    @required this.imageUrl,
    @required this.offerName,
  });
}
