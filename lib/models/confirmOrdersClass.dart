import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/cupertino.dart';

class ConfirmOrdersClass {
  final String id, orderId, name, email, contact, address, userLocalId, status;
  final double amount;
  final List<CartItem> cartProducts;
  final DateTime dateTime;

  ConfirmOrdersClass({
    @required this.id,
    @required this.orderId,
    @required this.name,
    @required this.email,
    @required this.contact,
    @required this.address,
    @required this.userLocalId,
    @required this.cartProducts,
    @required this.amount,
    @required this.dateTime,
    @required this.status,
  });
}
