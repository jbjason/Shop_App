import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/cupertino.dart';

class ConfitemOrdersClass {
  final String orderId, name, email, contact, address, userLocalId;
  final double total;
  final List<CartItem> cartProducts;

  ConfitemOrdersClass({
    @required this.orderId,
    @required this.name,
    @required this.email,
    @required this.contact,
    @required this.address,
    @required this.userLocalId,
    @required this.cartProducts,
    @required this.total,
  });
}
