import 'package:Shop_App/widgets/product_detail_screen_item.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  String currentImageUrl;
  int _isInit = 1;
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<String> _locations = ['M', 'L', 'XL', 'XXL'];
  String _selectedLocation;
  int count = 1;

  void currentimage(String url) {
    setState(() {
      widget.currentImageUrl = url;
      widget._isInit++;
    });
  }

  Widget countButton(Icon iconn, Function f) {
    return SizedBox(
      height: 28,
      width: 28,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: iconn,
        onPressed: f,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context, listen: false);
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
      body: ProductDetailScreenItem(),
    );
  }
}

// // Color widget
// class ColorPin extends StatelessWidget {
//   final Color c;
//   const ColorPin({
//     this.c,
//     Key key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       //onTap: () => ,
//       child: Container(
//         margin: EdgeInsets.only(top: 5, left: 5),
//         padding: EdgeInsets.all(2.5),
//         height: 20,
//         width: 20,
//         decoration: BoxDecoration(
//             color: c,
//             shape: BoxShape.circle,
//             border: Border.all(width: 2, color: c)),
//         child: DecoratedBox(
//           decoration: BoxDecoration(color: c, shape: BoxShape.circle),
//         ),
//       ),
//     );
//   }
// }
