import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final double _currentPrice =
        product.extra != "no" && product.extra != "combo"
            ? double.parse(product.extra)
            : product.price;
    return Stack(
      children: <Widget>[
        Card(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 2.0),
            height: 180.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(100.0, 5.0, 5.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Container(
                    width: 120.0,
                    child: Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // reviews
                  Row(children: [
                    Icon(
                      Icons.location_on_sharp,
                      size: 10.0,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      '${product.isReview} reviews',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.grey),
                    ),
                  ]),
                  // ratings
                  _buildRatingStars(product.isRating.toInt()),
                  SizedBox(height: 5),
                  // Price
                  Text(
                    ' \$${product.price}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        color: Color(0xFFFDD34A)),
                  ),
                  // favorite & cart Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.brown),
                        onPressed: () {
                          product.toggleFavoriteStatus(
                              authData.token, authData.userId);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.brown,
                        ),
                        onPressed: () {
                          cart.addItem(
                              product.id,
                              _currentPrice,
                              product.imageUrl1,
                              product.title,
                              1,
                              product.colorList[0],
                              product.sizeList[0]);
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Added item to Cart!'),
                            duration: Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cart.removeSingleItem(product.id);
                              },
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // image
        Positioned(
          left: 20.0,
          top: 15.0,
          bottom: 15.0,
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black26)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: product.id,
                  );
                },
                child: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    placeholder:
                        AssetImage('assets/images/product-placeholder.png'),
                    image: NetworkImage(
                      product.imageUrl1,
                    ),
                    width: 110.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.of(context).pushNamed(
    //           ProductDetailScreen.routeName,
    //           arguments: product.id,
    //         );
    //       },
    //       // hero annimation & product Image
    //       child: Hero(
    //         tag: product.id,
    //         child: FadeInImage(
    //           placeholder: AssetImage('assets/images/product-placeholder.png'),
    //           image: NetworkImage(product.imageUrl1),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     footer: GridTileBar(
    //       backgroundColor: Colors.black87,
    //       leading: Consumer<Product>(
    //         builder: (ctx, product, _) => IconButton(
    //           icon: Icon(
    //             product.isFavorite ? Icons.favorite : Icons.favorite_border,
    //           ),
    //           onPressed: () {
    //             product.toggleFavoriteStatus(authData.token, authData.userId);
    //           },
    //           color: Colors.red,
    //         ),
    //       ),
    //       // title text
    //       title: Text(product.title),
    //       // cart icon
    //       // trailing: IconButton(
    //   icon: Icon(Icons.shopping_cart),
    //   onPressed: () {
    //     cart.addItem(product.id, _currentPrice, product.imageUrl1,
    //         product.title, 1);
    //     Scaffold.of(context).hideCurrentSnackBar();
    //     Scaffold.of(context).showSnackBar(SnackBar(
    //       content: Text('Added item to Cart!'),
    //       duration: Duration(seconds: 1),
    //       action: SnackBarAction(
    //         label: 'UNDO',
    //         onPressed: () {
    //           cart.removeSingleItem(product.id);
    //         },
    //       ),
    //     ));
    //   },
    //   color: Colors.green,
    // ),
    //     ),
    //   ),
    // );
  }
}
