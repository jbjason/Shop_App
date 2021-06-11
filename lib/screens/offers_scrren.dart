import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  static const routeName = '/offers-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Color(0xFFC8E6C9),
      title: Text('Available Offers'),
    ));
  }
}
