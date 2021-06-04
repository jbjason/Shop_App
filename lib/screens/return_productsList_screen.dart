import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnProductsListScreen extends StatefulWidget {
  static const routeName = '/return-products-list';
  @override
  _ReturnProductsListScreenState createState() =>
      _ReturnProductsListScreenState();
}

class _ReturnProductsListScreenState extends State<ReturnProductsListScreen> {
  var _isInit = false;
  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      Provider.of<Orders>(context).fetchAndSetReturnList();
    }
    _isInit = true;
    print('jb');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        centerTitle: true,
        title: Text('Return Prod List'),
      ),
    );
  }
}
