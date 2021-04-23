import 'package:Shop_App/screens/orderDetailsScreen.dart';
import '../providers/cart.dart' show Cart;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

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
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFC8E6C9),
          title: Text('Your Cart',
              style: TextStyle(fontSize: 20, color: Colors.black))),
      body: Column(
        children: [
          Card(
            elevation: 8,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total ',
                    style: TextStyle(fontSize: 30),
                  ),
                  // it takes all free space as reserved
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  //OrderButton(cart: cart),
                  FlatButton(
                    onPressed: (cart.totalAmount <= 0)
                        ? null
                        : () {
                            Navigator.of(context)
                                .pushNamed(OrderDetailsScreen.routeName);
                          },
                    child: Text('Order Now'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
              // if we wanna fetch a value from selected Map item then we
              // need to add .values.toList()
              cart.items.values.toList()[i].id,
              // special keyword to get the selected id's random key
              cart.items.keys.toList()[i],
              cart.items.values.toList()[i].title,
              cart.items.values.toList()[i].price,
              cart.items.values.toList()[i].quantity,
              cart.items.values.toList()[i].imageUrl,
              updateCart,
            ),
            itemCount: cart.itemCount,
          )),
        ],
      ),
    );
  }
}

// class OrderButton extends StatefulWidget {
//   const OrderButton({
//     Key key,
//     @required this.cart,
//   }) : super(key: key);
//   final Cart cart;

//   @override
//   _OrderButtonState createState() => _OrderButtonState();
// }

// class _OrderButtonState extends State<OrderButton> {
//   var _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
//       textColor: Theme.of(context).primaryColor,
//       onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
//           ? null
//           : () async {
//               setState(() {
//                 _isLoading = true;
//               });
//               await Provider.of<Orders>(context, listen: false).addOrder(
//                 widget.cart.items.values.toList(),
//                 widget.cart.totalAmount,
//               );
//               setState(() {
//                 _isLoading = false;
//               });
//               widget.cart.clear();
//             },
//     );
//   }
// }
