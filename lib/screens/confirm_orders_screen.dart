import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmOrdersScreen extends StatefulWidget {
  static const routeName = '/confirm-orders-screen';
  @override
  _ConfirmOrdersScreenState createState() => _ConfirmOrdersScreenState();
}

class _ConfirmOrdersScreenState extends State<ConfirmOrdersScreen> {
  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).fetchAndSetConfiremOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Customer Orders',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
      body: Container(),
    );
  }
}
