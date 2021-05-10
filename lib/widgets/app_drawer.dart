import 'package:Shop_App/providers/cart.dart';
import 'package:provider/provider.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  Widget pointBar(int p) {
    RangeValues values = RangeValues(0, p.toDouble());
    return RangeSlider(
      values: values,
      min: 0,
      max: 100,
      divisions: 50,
      labels: RangeLabels(
        values.start.round().toString(),
        values.end.round().toString(),
      ),
      onChanged: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        //color: Colors.blueAccent,
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Hello Friend !',
                style: TextStyle(fontSize: 20),
              ),
              // back button disable
              automaticallyImplyLeading: false,
            ),
            // simply Horizontal Line
            Divider(),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context).pushNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 40),
              child: pointBar(0),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('LogOut',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
                Provider.of<Cart>(context, listen: false).clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
