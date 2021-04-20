import 'package:Shop_App/widgets/comments.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<String> _locations = ['M', 'L', 'XL', 'XXL'];
  String _selectedLocation;
  int count = 1;

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
    final cart = Provider.of<Cart>(context, listen: false);
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);

    return Scaffold(
      backgroundColor: Color(0xFFFFE0B2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          backgroundColor: Color(0xFFC8E6C9),
          title: Text(
            loadedProduct.title,
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.shopping_cart,
                      color: Theme.of(context).accentColor),
                  onPressed: () {
                    cart.addItem(
                      loadedProduct.id,
                      loadedProduct.price,
                      loadedProduct.title,
                      //loadedProduct.imageUrl,
                      2.toString(),
                      count,
                    );
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Added item to Cart!'),
                      duration: Duration(seconds: 1),
                    ));
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Upper Container of the Stack
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60)),
              ),
            ),

            // Upper Container Internal Work
            Container(
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image Container
                  Container(
                    height: 180,
                    width: 180,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Hero(
                        tag: loadedProduct.id,
                        child: Image.network(
                          loadedProduct.imageUrl,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // color Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // color widget
                      ColorPin(c: Color(0xFFD50000)),
                      ColorPin(c: Color(0xFF009688)),
                      ColorPin(c: Color(0xFF1565C0))
                    ],
                  ),
                  SizedBox(height: 20),

                  // Title Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ${loadedProduct.title}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SmoothStarRating(
                        size: 23,
                        borderColor: Colors.amber,
                        color: Colors.black,
                        spacing: 2.0,
                        //rating: ratingg,
                        // onRated: (value) {
                        //   ratingg = (ratingg + value) / 2;
                        // },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  // Price Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$ ${loadedProduct.price}',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(' Subtitle '),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Description Text
                  Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                  SizedBox(height: 70),

                  // Item Count & Size DropDown box
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          countButton(Icon(Icons.remove), () {
                            setState(() {
                              count--;
                            });
                          }),
                          SizedBox(
                            width: 8,
                          ),
                          Text(count.toString().padLeft(2, '0'),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 8,
                          ),
                          countButton(Icon(Icons.add), () {
                            setState(() {
                              count++;
                            });
                          }),
                        ],
                      ),
                      DropdownButton(
                          hint: Text(
                            'Choose Size',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          value: _selectedLocation,
                          items: _locations.map((e) {
                            return DropdownMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.format_size),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(e),
                                ],
                              ),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _selectedLocation = newVal;
                            });
                          }),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Order Now text Container
                  Container(
                    height: 37,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(),
                    ),
                    child: Text(
                      'ORDER NOW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            Comments(),
          ],
        ),
      ),
    );
  }
}

// Color widget
class ColorPin extends StatelessWidget {
  final Color c;
  const ColorPin({
    this.c,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 5),
      padding: EdgeInsets.all(2.5),
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: c)),
      child: DecoratedBox(
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      ),
    );
  }
}
