import '../providers/cart.dart';
import '../screens/return_product_screen.dart';
import '../screens/suggestion_Report_Screen.dart';
import 'package:provider/provider.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          //color: Color(0xFF4A4A58),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Jb Jason'),
                accountEmail: Text(auth.userEmail),
                currentAccountPicture: CircleAvatar(
                  child: FlutterLogo(
                    size: 50,
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
                leading: Icon(Icons.help),
                title: Text('Suggestion or Report'),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      SuggestionReportScreen.routeName,
                      arguments: [auth.userEmail]);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.sanitizer),
                title: Text('Return Product'),
                onTap: () {
                  Navigator.of(context).pushNamed(ReturnProductScreen.routeName,
                      arguments: [auth.userEmail]);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.album_outlined),
                title: Text('About Us'),
                onTap: () {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                ' About Us ',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            content: AboutUsMessages(),
                          ));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.mediation),
                title: Text('HelpLine..'),
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'HELPLINE',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      content: HelpLineContacts(),
                    ),
                  );
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
      ),
    );
  }
}

class HelpLineContacts extends StatelessWidget {
  const HelpLineContacts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Developers :\n\n',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          TextSpan(
            text: '   -   Email:    ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'itisjubayer@gmail.com\n',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black),
          ),
          TextSpan(
            text: '   -   Contact:  ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: '0162843****\n\n',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black),
          ),
          TextSpan(
            text: '   -  Email:   ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'tahminasorovi95@gmail\n',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          TextSpan(
            text: '   -  Contact:   ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: '0191050****\n\n',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          TextSpan(
            text: '   -  Email:   ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'tanmoysarker233@gmail.com\n',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          TextSpan(
            text: '   -  Contact:   ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: '0176264****\n\n',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class AboutUsMessages extends StatelessWidget {
  const AboutUsMessages({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Supervisor :\n\n',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          WidgetSpan(
            child: Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/shamim.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          TextSpan(
            text: '     Email: ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'shamim.a@bubt.edu.bd\n\n\n\n',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                //fontSize: 16,
                color: Colors.black),
          ),
          TextSpan(
            text: 'Developers :\n\n',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          WidgetSpan(
            child: Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/jb.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          TextSpan(
            text: '     Email: ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'itisjubayer@gmail.com\n\n',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                //fontSize: 16,
                color: Colors.black),
          ),
          WidgetSpan(
            child: Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/tahmina.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          TextSpan(
            text: '     Email: ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'tahminasorovi95@gmail\n\n',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                // fontSize: 16,
                color: Colors.black),
          ),
          WidgetSpan(
            child: Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/tanmoy.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          TextSpan(
            text: '     Email: ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'tanmoysarker233@gmail',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                //fontSize: 16,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
