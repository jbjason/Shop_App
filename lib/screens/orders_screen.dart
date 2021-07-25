import '../screens/order_details_screen.dart';
import '../widgets/userProfile.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import 'package:flutter/services.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';
  int _selectCount = 2, _selectDays = 0, _length = 0;
  bool _showAll = true;
  List<dynamic> _userTransaction = [];
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    final size = MediaQuery.of(context).size;
    final connection =
        ModalRoute.of(context).settings.arguments as List<String>;
    final product = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: AppDrawer()),
      body: FutureBuilder(
        future: product.fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (widget._selectDays == 0) {
            widget._length = product.orders.length;
          }
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // if an error occurs
            if (dataSnapshot.error != null) {
              return Container(height: 300, child: Text('An error occured'));
            } else if (connection[0] == "profile") {
              return Container(
                  child: UserProfile(connection[2], connection[3]));
            } else {
              return Stack(children: [
                YellowDesign(size),
                Column(children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 6),
                  Row(children: [
                    IconButton(
                        alignment: Alignment.topLeft,
                        icon: Icon(
                          Icons.menu,
                          size: 24,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        }),
                    Spacer(),
                    PopupMenuButton(
                        onSelected: (int selectedIndex) {
                          if (selectedIndex == 0) {
                            setState(() {
                              widget._showAll = false;
                              // checking orders.length is lesser than 5 or not
                              int _existingOrders = product.orders.length;
                              if (widget._selectCount > _existingOrders) {
                                widget._selectCount = _existingOrders;
                              }
                              widget._selectDays = 0;
                            });
                          } else if (selectedIndex == 3) {
                            setState(() {
                              widget._showAll = true;
                              widget._selectDays = 0;
                              widget._length = product.orders.length;
                            });
                          } else if (selectedIndex == 2) {
                            setState(() {
                              widget._selectDays = 15;
                              widget._userTransaction =
                                  product.recentTransactions(15);
                              widget._length = widget._userTransaction.length;
                            });
                          } else {
                            setState(() {
                              widget._selectDays = 30;
                              widget._userTransaction =
                                  product.recentTransactions(30);
                              widget._length = widget._userTransaction.length;
                            });
                          }
                        },
                        icon: connection[0] == "profile"
                            ? Icon(null)
                            : Icon(Icons.more_vert),
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
                            ]),
                  ]),
                  Text(
                    connection[1] == null ? '' : connection[1],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 64),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Consumer<Orders>(
                        builder: (ctx, orderData, child) =>
                            orderData.orders.length < 1
                                ? Container(
                                    height: 300,
                                    alignment: Alignment.center,
                                    child:
                                        Text('You didn\'t orders anything :('))
                                : ListView.builder(
                                    itemBuilder: (ctx, i) => OrderItem(
                                        widget._selectDays == 0
                                            ? orderData.orders[i]
                                            : widget._userTransaction[i],
                                        i),
                                    itemCount: widget._showAll == false
                                        ? widget._selectCount
                                        : widget._length),
                      ),
                    ),
                  ),
                ]),
              ]);
            }
          }
        },
      ),
    );
  }
}
