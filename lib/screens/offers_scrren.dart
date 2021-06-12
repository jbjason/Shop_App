import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffersScreen extends StatefulWidget {
  static const routeName = '/offers-screen';
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    Provider.of<Products>(context, listen: false).fetchOffersUptoAmount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Color(0xFFC8E6C9),
      title: Text('Available Offers'),
    ));
  }
}
