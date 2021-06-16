import 'package:Shop_App/widgets/product_detail_screen_item.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(45),
      //   child: AppBar(
      //     backgroundColor: Color(0xFFC8E6C9),
      //     title: Text(
      //       loadedProduct.title,
      //       style: TextStyle(color: Colors.black87),
      //     ),
      //     actions: [
      //       Builder(
      //         builder: (BuildContext context) {
      //           return IconButton(
      //             icon: Icon(Icons.shopping_cart,
      //                 color: Theme.of(context).accentColor),
      //             onPressed: () {
      //               cart.addItem(
      //                 loadedProduct.id,
      //                 loadedProduct.price,
      //                 loadedProduct.imageUrl1,
      //                 loadedProduct.title,
      //                 1,
      //               );
      //               Scaffold.of(context).showSnackBar(SnackBar(
      //                 content: Text('Added item to Cart!'),
      //                 duration: Duration(seconds: 1),
      //               ));
      //             },
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: ProductDetailScreenItem(
        loadedProduct.id,
        loadedProduct.title,
        loadedProduct.description,
        loadedProduct.price,
        loadedProduct.imageUrl1,
        loadedProduct.imageUrl2,
        loadedProduct.imageUrl3,
        loadedProduct.isRating,
        loadedProduct.isReview,
        loadedProduct.extra,
      ),
    );
  }
}
