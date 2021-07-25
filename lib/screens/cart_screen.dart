import 'order_details_screen.dart';
import '../providers/cart.dart' show Cart;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import 'package:flutter/services.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void updateCart(String idd, int countt) {
    setState(() {
      Provider.of<Cart>(context, listen: false).update(idd, countt);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFDD148),
      statusBarBrightness: Brightness.light,
    ));
    final cart = Provider.of<Cart>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(children: [
          ListView(children: [
            YellowForCart(size: size),
            Container(
              height: size.height * .64,
              color: Colors.white,
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      elevation: 16,
                      child: Container(
                          height: 55.0,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 100),
                              Text('Total: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17)),
                              Chip(
                                label: Text(
                                  '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: (cart.totalAmount <= 0)
                                      ? null
                                      : () {
                                          Navigator.of(context).pushNamed(
                                              OrderDetailsScreen.routeName);
                                        },
                                  elevation: 0.5,
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'Settlement',
                                    ),
                                  ),
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          ]),
          Positioned(
            bottom: size.height * .1,
            child: cart.itemCount < 1
                ? Container(
                    height: 300, child: Text('No items available yet :('))
                : Container(
                    height: size.height * .64,
                    width: size.width,
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => CartItem(
                        // if we wanna fetch a value from selected Map item then we
                        // need to add .values.toList()
                        cart.items.values.toList()[i].id,
                        // special keyword to get the selected id's random key ,which will be needed to update,delete the cart items
                        cart.items.keys.toList()[i],
                        cart.items.values.toList()[i].title,
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                        cart.items.values.toList()[i].imageUrl,
                        updateCart,
                        cart.items.values.toList()[i].color,
                        cart.items.values.toList()[i].size,
                      ),
                      itemCount: cart.itemCount,
                    )),
          ),
        ]),
      ),
    );
  }
}

class YellowForCart extends StatelessWidget {
  const YellowForCart({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .32,
      width: size.width,
      color: Color(0xFFFDD148),
      child: Stack(children: [
        Positioned(
          right: 100.0,
          child: Container(
            height: 400.0,
            width: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: Color(0xFFFEE16D),
            ),
          ),
        ),
        Positioned(
          bottom: 5.0,
          left: 150.0,
          child: Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Color(0xFFFEE16D).withOpacity(0.5))),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        Positioned(
            top: 75.0,
            left: 15.0,
            child: Text(
              'Shopping Cart',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            )),
      ]),
    );
  }
}

// body: Column(
      //   children: [
      //     Card(
      //       elevation: 8,
      //       margin: EdgeInsets.all(15),
      //       child: Padding(
      //         padding: EdgeInsets.all(8),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               'Total ',
      //               style: TextStyle(fontSize: 30),
      //             ),
      //             // it takes all free space as reserved
      //             Spacer(),
      //             Chip(
      //               label: Text(
      //                 '\$ ${cart.totalAmount.toStringAsFixed(2)}',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //               backgroundColor: Theme.of(context).primaryColor,
      //             ),
      //             //OrderButton(cart: cart),
      //             FlatButton(
      //               onPressed: (cart.totalAmount <= 0)
      //                   ? null
      //                   : () {
      //                       Navigator.of(context)
      //                           .pushNamed(OrderDetailsScreen.routeName);
      //                     },
      //               child: Text('Order Now'),
      //               textColor: Theme.of(context).primaryColor,
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //     SizedBox(height: 10),
      // Expanded(
      //     child: ListView.builder(
      //   itemBuilder: (ctx, i) => CartItem(
      //     // if we wanna fetch a value from selected Map item then we
      //     // need to add .values.toList()
      //     cart.items.values.toList()[i].id,
      //     // special keyword to get the selected id's random key ,which will be needed to update,delete the cart items
      //     cart.items.keys.toList()[i],
      //     cart.items.values.toList()[i].title,
      //     cart.items.values.toList()[i].price,
      //     cart.items.values.toList()[i].quantity,
      //     cart.items.values.toList()[i].imageUrl,
      //     updateCart,
      //     cart.items.values.toList()[i].color,
      //     cart.items.values.toList()[i].size,
      //   ),
      //   itemCount: cart.itemCount,
      // )),
      //   ],
      // ),