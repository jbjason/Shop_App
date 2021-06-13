import 'package:flutter/material.dart';

class SetNextDayOfferScreen extends StatefulWidget {
  static const routeName = '/next-day-offer';

  @override
  _SetNextDayOfferScreenState createState() => _SetNextDayOfferScreenState();
}

class _SetNextDayOfferScreenState extends State<SetNextDayOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Manage Offers'),
      ),
    );
  }
}
