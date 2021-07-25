import '../screens/product_detail_screen.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../screens/order_details_screen.dart';
import '../widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ViewOfferScreen extends StatefulWidget {
  static const routeName = '/view-offer-screen';
  @override
  _ViewOfferScreenState createState() => _ViewOfferScreenState();
}

class _ViewOfferScreenState extends State<ViewOfferScreen> {
  var _isSpecial = true, _isCombo = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFDD148),
      statusBarBrightness: Brightness.light,
    ));
    final size = MediaQuery.of(context).size;
    final String _check = ModalRoute.of(context).settings.arguments as String;
    final productsData = Provider.of<Products>(context, listen: false);
    final products = _check == "sortBy"
        ? productsData.getSortProducts
        : _isSpecial
            ? productsData.specialOfferItems
            : productsData.comboOfferItems;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color(0xFFC8E6C9),
        //   title: Text('Offer Products',
        //       style: TextStyle(fontSize: 20, color: Colors.black)),
        //   actions: [
        //     Consumer<Cart>(
        //       builder: (_, cart, ch) =>
        //           Badge(child: ch, value: cart.itemCount.toString()),
        //       child: IconButton(
        //         icon: Icon(Icons.shopping_cart),
        //         onPressed: () {
        //           Navigator.of(context).pushNamed(CartScreen.routeName);
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        body: Stack(children: [
          YellowDesign(size),
          Column(children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(shrinkWrap: true, children: [
                Row(children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 24),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Spacer(),
                  Consumer<Cart>(
                    builder: (_, cart, ch) =>
                        Badge(child: ch, value: cart.itemCount.toString()),
                    child: IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(
                        Icons.shopping_basket,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),
                ]),
                Text(
                  ' Exciting Offers',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                _check == "sortBy"
                    ? Container()
                    : Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isSpecial = true;
                                  _isCombo = false;
                                });
                              },
                              child: Container(
                                height: 65,
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _isSpecial
                                      ? Colors.blueGrey[50]
                                      : Colors.blueGrey[50].withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Card(
                                  elevation: 8,
                                  child: Center(
                                    child: Text(
                                      'SPECIAL Offer',
                                      style: TextStyle(
                                        color: _isSpecial
                                            ? Colors.black
                                            : Colors.black54,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isCombo = true;
                                  _isSpecial = false;
                                });
                              },
                              child: Container(
                                height: 65,
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _isCombo
                                      ? Colors.blueGrey[50]
                                      : Colors.blueGrey[50].withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Card(
                                  elevation: 8,
                                  child: Center(
                                    child: Text(
                                      'COMBO Offer',
                                      style: TextStyle(
                                        color: _isCombo
                                            ? Colors.black
                                            : Colors.black26,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                Container(
                  height: products.length * 250.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        ViewOfferItem(item: products[index]),
                    itemCount: products.length,
                  ),
                ),
              ]),
            )),
          ]),
        ]),
      ),
    );
  }
}

class ViewOfferItem extends StatelessWidget {
  const ViewOfferItem({
    @required this.item,
    Key key,
  }) : super(key: key);

  final Product item;
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐';
    }
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final double _currentPrice = item.extra != "no" && item.extra != "combo"
        ? double.parse(item.extra)
        : item.price;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(left: 5),
          height: 240,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                      arguments: item.id);
                },
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[300],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Container(
                          child: Image.network(
                            item.imageUrl1,
                            height: 210,
                            width: 140,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 30, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '\$${item.price}',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  item.extra == "no"
                                      ? Text('')
                                      : Text(
                                          '\$123',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 22.0,
                                            color: Colors.black26,
                                            fontWeight: FontWeight.w600,
                                            decorationColor: Colors.redAccent,
                                            decorationThickness: 1.4,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '${item.isReview}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // point ke int kore pass korte hobe
                          _buildRatingStars(item.isRating.toInt()),
                          SizedBox(height: 10.0),
                          Text('Available : ${item.available} /-'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(
                                  item.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                onPressed: () {
                                  item.toggleFavoriteStatus(
                                      authData.token, authData.userId);
                                },
                                color: Colors.red,
                              ),
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  cart.addItem(
                                      item.id,
                                      _currentPrice,
                                      item.imageUrl1,
                                      item.title,
                                      1,
                                      item.colorList[0],
                                      item.sizeList[0]);
                                  Scaffold.of(context).hideCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Added item to Cart!'),
                                    duration: Duration(seconds: 1),
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () {
                                        cart.removeSingleItem(item.id);
                                      },
                                    ),
                                  ));
                                },
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
