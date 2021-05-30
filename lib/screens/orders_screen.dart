import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final connection =
        ModalRoute.of(context).settings.arguments as List<String>;
    final matchKey = connection[0];
    final titleName = connection[1];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text(titleName),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // if an error occurs
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else if (matchKey == "profile") {
              return Container(child: Text('jb is a  loser'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
