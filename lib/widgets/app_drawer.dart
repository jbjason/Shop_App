import 'package:Shop_App/screens/products_overview_screen.dart';
import 'package:Shop_App/screens/statistic_screen.dart';
import 'package:Shop_App/screens/view_offer_screen.dart';
import '../providers/products.dart';
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
  bool _check(String s) {
    s = s.toLowerCase();
    if (s.contains('jst') && s.contains('690') && s.contains('#')) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final d = Divider(
      color: Colors.white.withOpacity(0.5),
      thickness: 1,
    );
    final bool _isAdmin =
        auth.userEmail == null ? '' : _check(auth.userEmail.toLowerCase());
    return SingleChildScrollView(
      child: Container(
        color: Color.fromRGBO(31, 58, 47, 1.0),
        child: Column(
          children: [
            Header(auth: auth),
            Divider(color: Colors.black, thickness: 3),
            // Myshop
            MyShop(),
            d,
            // Offers_screen
            OffersZone(),
            d,
            //sortBy
            Visibility(
              visible: !_isAdmin,
              child: SortByClass(),
            ),
            d,
            // manage products
            Visibility(visible: _isAdmin, child: ManageProducts()),
            d,
            // Offers List
            Visibility(visible: _isAdmin, child: OffersList()),

            d,
            // Manage Special/Combo Pric
            Visibility(visible: _isAdmin, child: ManageSpecialComboPrice()),

            d,
            // my Profile
            Visibility(
              visible: !_isAdmin,
              child: MyProfile(auth: auth),
            ),
            d,
            // My Orders
            Visibility(
              visible: !_isAdmin,
              child: MyOrders(),
            ),
            d,
            // cutomer orders
            Visibility(
              visible: _isAdmin,
              child: CustomerOrders(),
            ),
            d,
            // Return Product Form
            Visibility(
              visible: !_isAdmin,
              child: ReturnProductForm(auth: auth),
            ),
            d,
            // Return Prod List
            Visibility(
              visible: _isAdmin,
              child: ReturnProductList(),
            ),
            d,
            // Business Statistic
            Visibility(
              visible: _isAdmin,
              child: StatisTic(),
            ),
            d,
            // Suggestion or Report form
            Visibility(
              visible: !_isAdmin,
              child: SuggestionOrReport(auth: auth),
            ),
            d,
            //About Us
            AboutUs(),
            d,
            // HelpLine
            HelpLine(),
            d,
            // LogOut
            LogOut(),
          ],
        ),
      ),
    );
  }
}

class StatisTic extends StatelessWidget {
  const StatisTic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.bar_chart, color: Colors.white),
      title: Text('Business Statistic', style: t),
      onTap: () {
        Navigator.of(context).pushNamed(StatisticScreen.routeName);
      },
    );
  }
}

class SortByClass extends StatefulWidget {
  @override
  _SortByClassState createState() => _SortByClassState();
}

class _SortByClassState extends State<SortByClass> {
  bool _isExpand = false;
  double lowValue = 0, highValue = 1000;
  int _selectedIndex = 0;

  void _save(String cat) {
    // category unselected or price sortOut korte hobe
    Provider.of<Products>(context, listen: false)
        .setSortProducts(cat, highValue);
    Navigator.of(context)
        .pushNamed(ViewOfferScreen.routeName, arguments: 'sortBy');
  }

  Widget pointBar() {
    RangeValues values = RangeValues(lowValue, highValue);
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 10,
        thumbColor: Colors.red,
        activeTrackColor: Colors.red.shade200,
        inactiveTrackColor: Colors.red.shade50,
        rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 15),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
      ),
      child: RangeSlider(
        values: values,
        min: 0,
        max: 2800,
        divisions: 200,
        labels: RangeLabels(
          values.start.round().toString(),
          values.end.round().toString(),
        ),
        onChanged: (val) {
          setState(() {
            highValue = val.end;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    final List<String> _category =
        Provider.of<Products>(context, listen: false).categories;
    return Container(
      child: Column(
        children: [
          // SearchBy title
          ListTile(
            tileColor: _isExpand ? Colors.green[200] : Colors.transparent,
            leading: Icon(Icons.sort_sharp, color: Colors.white),
            title: Text(
              'Search By...',
              style: t,
            ),
            onTap: () {
              setState(() {
                _isExpand = !_isExpand;
              });
            },
          ),
          Container(
            height: _isExpand ? 550 : 0,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 18, bottom: 20),
                  color: Colors.black12,
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    'Sort By *(Price)',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('0',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('1000', style: TextStyle(fontSize: 15)),
                    Text('2000', style: TextStyle(fontSize: 15)),
                    Text('+',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                pointBar(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(''),
                    Text('500'),
                    Text('1500', style: TextStyle(fontSize: 15)),
                    Text('2500', style: TextStyle(fontSize: 15)),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 35, left: 18, bottom: 20),
                  color: Colors.black12,
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    'Sort By *(Category)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.only(left: 25),
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                      tileColor: index == _selectedIndex
                          ? Colors.orange[200]
                          : Colors.orange[50].withOpacity(0.8),
                      leading: Text('${index + 1}. '),
                      title: Text(_category[index]),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                    itemCount: _category.length,
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton.icon(
                      icon: Icon(Icons.swap_vert),
                      label: Text('   Apply'),
                      onPressed: () {
                        _save(_category[_selectedIndex]);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.sanitizer, color: Colors.white),
      title: Text('Return Product Form', style: t),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.help, color: Colors.white),
      title: Text(
        'Suggestion or Report',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.people_alt_outlined, color: Colors.white),
      title: Text(
        'Profile',
        style: t,
      ),
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
      accountName: Text('User1'),
      accountEmail: Text(
        auth.userEmail == null ? '' : auth.userEmail,
        style: TextStyle(fontWeight: FontWeight.w200),
      ),
      currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Image.asset(
            'assets/images/homeLogo2.jpeg',
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          )),
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }
}

class ReturnProductList extends StatelessWidget {
  const ReturnProductList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.sanitizer, color: Colors.white),
      title: Text(
        'Return Prod List',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.home, color: Colors.white),
      title: Text(
        'Shop',
        style: t,
      ),
      onTap: () {
        Navigator.of(context).pushNamed(ProductsOverviewScreen.routename);
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.corporate_fare, color: Colors.white),
      title: Text(
        'Customer Orders',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.payment, color: Colors.white),
      title: Text(
        'My Orders',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.edit, color: Colors.white),
      title: Text(
        'Manage Special/Combo Price',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.edit, color: Colors.white),
      title: Text(
        'Manage Products',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.card_giftcard, color: Colors.white),
      title: Text(
        'Offer\'s Zone',
        style: t,
      ),
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
      leading: Icon(Icons.exit_to_app, color: Colors.white),
      title: Text('LogOut',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w700)),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.mediation, color: Colors.white),
      title: Text(
        'HelpLine..',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return ListTile(
      leading: Icon(Icons.album_outlined, color: Colors.white),
      title: Text(
        'About Us',
        style: t,
      ),
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
    final t = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16,
      color: Colors.white,
    );
    return Container(
      height: _isExpand ? (60 * 5.0) : 60,
      child: Column(
        //itemExtent: 46,
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Colors.white),
            title: Text(
              'Manage Offer\'s',
              style: t,
            ),
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
                  leading: Icon(
                    Icons.minimize_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Special Offer', style: t),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SetNextDayOfferScreen.routeName,
                        arguments: 'specialOffer');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.minimize_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Upto \'N\' Tk Offer', style: t),
                  onTap: () {
                    Navigator.of(context).pushNamed(SetOffersScreen.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.minimize_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Next Day Delivery', style: t),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SetNextDayOfferScreen.routeName,
                        arguments: 'nextDayDelivery');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.minimize_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Combo Offer', style: t),
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
