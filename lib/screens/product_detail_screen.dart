import 'package:Shop_App/widgets/product_detail_screen_item.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    return Scaffold(
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
        loadedProduct.available,
        loadedProduct.category,
        loadedProduct.sizeList,
        loadedProduct.colorList,
      ),
    );
  }
}
