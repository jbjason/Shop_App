import 'package:flutter/material.dart';

class SetSpecialOfferScreen extends StatefulWidget {
  static const routeName = '/set-special-offer';

  @override
  _SetSpecialOfferScreenState createState() => _SetSpecialOfferScreenState();
}

class _SetSpecialOfferScreenState extends State<SetSpecialOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFC8E6C9),
          title: Text(
            'Manage Discount Price',
            style: TextStyle(fontSize: 20, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
