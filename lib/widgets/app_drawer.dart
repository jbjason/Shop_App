import 'package:Shop_App/providers/cart.dart';
import 'package:provider/provider.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Drawer(
      child: Container(
        //color: Colors.blueAccent,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Jb Jason'),
              accountEmail: Text(auth.userEmail),
              currentAccountPicture: CircleAvatar(
                child: FlutterLogo(
                  size: 90,
                ),
              ),
            ),
            // AppBar(
            //   title: Text(
            //     'Hello Friend !',
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   // back button disable
            //   automaticallyImplyLeading: false,
            // ),
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
              leading: Icon(Icons.people_alt_outlined),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName,
                    arguments: [
                      "profile",
                      "Your Profile",
                      auth.userEmail,
                      auth.userId
                    ]);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName,
                    arguments: ["order", "Your Orders"]);
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
