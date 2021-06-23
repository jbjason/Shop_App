import '../screens/set_nextDayOffer_screen.dart';
import '../screens/set_offers_screen.dart';
import '../screens/offers_scrren.dart';
import '../screens/customer_orders_screen.dart';
import '../screens/return_productsList_screen.dart';
import '../providers/cart.dart';
import '../screens/return_productForm_screen.dart';
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
              Header(auth: auth),
              // Myshop
              MyShop(),
              Divider(),
              // Offers_screen
              OffersZone(),
              Divider(),
              // manage products
              ManageProducts(),
              Divider(),
              // Offers List
              OffersList(),
              Divider(),
              // Manage Special/Combo Pric
              ManageSpecialComboPrice(),
              Divider(),
              // my Profile
              MyProfile(auth: auth),
              Divider(),
              // My Orders
              MyOrders(),
              Divider(),

              // cutomer orders
              CustomerOrders(),
              Divider(),
              // Return Product Form
              ReturnProductForm(auth: auth),
              Divider(),
              // Return Prod List
              ReturnProductList(),
              Divider(),
              // Suggestion or Report form
              SuggestionOrReport(auth: auth),
              Divider(),
              //About Us
              AboutUs(),
              Divider(),
              // HelpLine
              HelpLine(),
              Divider(),
              // LogOut
              LogOut(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReturnProductForm extends StatelessWidget {
  const ReturnProductForm({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.sanitizer),
      title: Text('Return Product Form'),
      onTap: () {
        Navigator.of(context).pushNamed(ReturnProductScreen.routeName,
            arguments: auth.userEmail);
      },
    );
  }
}

class SuggestionOrReport extends StatelessWidget {
  const SuggestionOrReport({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.help),
      title: Text('Suggestion or Report'),
      onTap: () {
        Navigator.of(context).pushNamed(SuggestionReportScreen.routeName,
            arguments: auth.userEmail);
      },
    );
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.people_alt_outlined),
      title: Text('Profile'),
      onTap: () {
        Navigator.of(context).pushNamed(OrderScreen.routeName, arguments: [
          "profile",
          "Your Profile",
          auth.userEmail,
          auth.userId
        ]);
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text('Jb Jason'),
      accountEmail: Text(auth.userEmail),
      currentAccountPicture: CircleAvatar(
        child: FlutterLogo(
          size: 50,
        ),
      ),
    );
  }
}

class ReturnProductList extends StatelessWidget {
  const ReturnProductList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.sanitizer),
      title: Text('Return Prod List'),
      onTap: () {
        Navigator.of(context).pushNamed(ReturnProductsListScreen.routeName);
      },
    );
  }
}

class MyShop extends StatelessWidget {
  const MyShop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.shop),
      title: Text('Shop'),
      onTap: () {
        Navigator.of(context).pushNamed('/');
      },
    );
  }
}

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.corporate_fare),
      title: Text('Customer Orders'),
      onTap: () {
        Navigator.of(context).pushNamed(CustomerOrdersScreen.routeName);
      },
    );
  }
}

class MyOrders extends StatelessWidget {
  const MyOrders({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.payment),
      title: Text('My Orders'),
      onTap: () {
        Navigator.of(context).pushNamed(OrderScreen.routeName,
            arguments: ["order", "Your Orders"]);
      },
    );
  }
}

class ManageSpecialComboPrice extends StatelessWidget {
  const ManageSpecialComboPrice({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Manage Special/Combo Price'),
      onTap: () {
        Navigator.of(context)
            .pushNamed(UserProductsScreen.routeName, arguments: 'offer');
      },
    );
  }
}

class ManageProducts extends StatelessWidget {
  const ManageProducts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text('Manage Products'),
      onTap: () {
        Navigator.of(context)
            .pushNamed(UserProductsScreen.routeName, arguments: 'product');
      },
    );
  }
}

class OffersZone extends StatelessWidget {
  const OffersZone({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.card_giftcard),
      title: Text('Offer\'s Zone'),
      onTap: () {
        Navigator.of(context).pushNamed(OffersScreen.routeName);
      },
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('LogOut',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<Auth>(context, listen: false).logout();
        Provider.of<Cart>(context, listen: false).clear();
      },
    );
  }
}

class HelpLine extends StatelessWidget {
  const HelpLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

class OffersList extends StatefulWidget {
  @override
  _OffersListState createState() => _OffersListState();
}

class _OffersListState extends State<OffersList> {
  bool _isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isExpand ? (60 * 5.0) : 60,
      child: Column(
        //itemExtent: 46,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Offer\'s'),
            onTap: () {
              setState(() {
                _isExpand = !_isExpand;
              });
            },
          ),
          Container(
            height: _isExpand ? 60 * 4.0 : 0,
            margin: EdgeInsets.only(left: 40),
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                // special offer & next day delivery is connected on pic uploading
                ListTile(
                  leading: Icon(Icons.minimize_rounded),
                  title: Text('Special Offer'),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SetNextDayOfferScreen.routeName,
                        arguments: 'specialOffer');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.minimize_rounded),
                  title: Text('Upto \'N\' Tk Offer'),
                  onTap: () {
                    Navigator.of(context).pushNamed(SetOffersScreen.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.minimize_rounded),
                  title: Text('Next Day Delivery'),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SetNextDayOfferScreen.routeName,
                        arguments: 'nextDayDelivery');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.minimize_rounded),
                  title: Text('Combo Offer'),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SetNextDayOfferScreen.routeName,
                        arguments: 'comboOffer');
                  },
                ),
              ],
            ),
          ),
        ],
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
