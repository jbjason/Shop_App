import 'package:Shop_App/widgets/userProfile.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';
  int _selectCount = 5;
  bool _showAll = true;
  int _existingOrders = 0;
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final connection =
        ModalRoute.of(context).settings.arguments as List<String>;
    final product = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text(connection[1]),
        actions: [
          PopupMenuButton(
            onSelected: (int selectedIndex) {
              if (selectedIndex == 0) {
                setState(() {
                  widget._showAll = false;
                  // checking orders.length is lesser than 5 or not

                  if (widget._selectCount > widget._existingOrders) {
                    widget._selectCount = widget._existingOrders;
                  }
                });
              } else if (selectedIndex == 3) {
                setState(() {
                  widget._showAll = true;
                });
              } else if (selectedIndex == 2) {
                setState(() {
                  //_selectCount = 15;
                });
              } else {
                setState(() {
                  //_selectCount = 30;
                });
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Last Five Orders'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Last 15 days'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Last 30 days'),
                value: 2,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: 3,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: product.fetchAndSetOrders(),
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
            } else if (connection[0] == "profile") {
              return Container(
                  child: UserProfile(connection[2], connection[3]));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                  itemCount: widget._showAll == false
                      ? widget._selectCount
                      : orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
