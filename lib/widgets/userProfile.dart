import '../providers/orders.dart' show Orders;
import 'package:Shop_App/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class UserProfile extends StatelessWidget {
  final String email, userId;
  UserProfile(this.email, this.userId);
  @override
  Widget build(BuildContext context) {
    final _userTransactions =
        Provider.of<Orders>(context, listen: false).recentTransactions(7);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(children: [
            IconButton(
              // alignment: Alignment.topLeft,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Spacer()
          ]),
          //profile image
          Container(
            height: 150,
            width: 150,
            margin: EdgeInsets.only(top: 20, bottom: 15),
            child: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/pinch2.png',
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Local Id
          Container(
            width: size.width,
            child: Row(
              children: [
                Container(
                  width: size.width * .35,
                  // color: Colors.amber,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Local_Id  :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(width: size.width * .05),
                Expanded(
                  child: TextFormField(
                    initialValue: "  " + userId,
                    readOnly: true,
                  ),
                ),
                SizedBox(width: size.width * .1),
              ],
            ),
          ),
          // User Email
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  // color: Colors.blue,
                  width: size.width * .35,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'User_Email :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: size.width * .05),
                Expanded(
                  child: TextFormField(
                    initialValue: "  " + email,
                    readOnly: true,
                  ),
                ),
                SizedBox(width: size.width * .1),
              ],
            ),
          ),
          // History text
          Container(
            //height: 300,
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.all(20),
              // comment section Row
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'History ',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.history_rounded,
                        size: 30,
                      ),
                    ],
                  ),
                  Text('(  last seven days  )'),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          // Chart Bar
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .27,
            child: Chart(_userTransactions),
          ),
          // Chart List
          Container(
            height: 300,
            child: ListView.builder(
              itemBuilder: (ctx, i) => OrderItem(_userTransactions[i], i),
              itemCount: _userTransactions.length,
            ),
          ),
        ],
      ),
    );
  }
}
