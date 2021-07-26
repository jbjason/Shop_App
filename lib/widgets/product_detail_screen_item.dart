import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/product.dart';
import 'package:Shop_App/providers/products.dart';
import 'package:Shop_App/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:Shop_App/widgets/comments.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class ProductDetailScreenItem extends StatefulWidget {
  final String image2, image1, image3, id, extra, category;
  final String _title, _description;
  final double price;
  final int _available;
  final List<String> colorList, sizeList;
  double rating;
  int review;
  String currentImageUrl;
  int _isInit = 1;

  ProductDetailScreenItem(
    this.id,
    this._title,
    this._description,
    this.price,
    this.image1,
    this.image2,
    this.image3,
    this.rating,
    this.review,
    this.extra,
    this._available,
    this.category,
    this.sizeList,
    this.colorList,
  );
  @override
  _ProductDetailScreenItemState createState() =>
      _ProductDetailScreenItemState();
}

class _ProductDetailScreenItemState extends State<ProductDetailScreenItem> {
  final primaryColor = const Color(0xFF0C9869);
  final backgroundColor = const Color(0xFFF9F8FD);
  List<String> _comments = [];
  String selectedColor, selectedSize;
  int sColor = 0, sSize = 0;
  int _isComment = 1;

  double percentageCount() {
    double d = (double.parse(widget.extra) * 100.0) / widget.price;
    return d -= 100.0;
  }

  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .fetchAndSetComments(widget.id);
    super.initState();
  }

  void currentimage(String url) {
    setState(() {
      widget.currentImageUrl = url;
      widget._isInit++;
    });
  }

  Widget _iconWidget(String url) {
    return GestureDetector(
      onTap: () => currentimage(url),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 5),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 22,
              color: primaryColor,
            ),
            BoxShadow(
              offset: Offset(-15, -15),
              blurRadius: 20,
              color: Colors.white,
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.network(url),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final product = Provider.of<Products>(context);
    final bool _offerAvailable = widget.extra == "no" ? false : true;
    _comments = product.commentsList;
    final String firstColor = widget.colorList[0].toLowerCase(),
        firstSize = widget.sizeList[0].toLowerCase();
    return SingleChildScrollView(
      child: Column(
        children: [
          // Pic & ratings part
          Container(
            height: size.height * .8,
            width: size.width,
            color: Color(0xFFE8F5E9).withOpacity(0.4),
            child: SizedBox(
              child: Row(
                children: [
                  Container(
                    height: size.height * .7,
                    width: size.width * .22,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          //alignment: Alignment.topLeft,
                          child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                        //SizedBox(height: 30),
                        _iconWidget(widget.image1),
                        if (widget.image2.isNotEmpty)
                          _iconWidget(widget.image2),
                        if (widget.image3.isNotEmpty)
                          _iconWidget(widget.image3),
                      ],
                    ),
                  ),

                  // right side
                  Container(
                    width: size.width * .78,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(63),
                            bottomLeft: Radius.circular(63),
                          ),
                          child: PinchZoom(
                            image: Image.network(
                              widget._isInit == 1
                                  ? widget.image1
                                  : widget.currentImageUrl,
                              height: size.height,
                              width: size.width,
                              fit: BoxFit.cover,
                            ),
                            zoomedBackgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        // positioned of ratings & all
                        PositionedWidget(size: size, widget: widget)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Title , reviews , Price_Clipper
          Container(
            color: Color(0xFFE8F5E9).withOpacity(0.5),
            margin: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // title & review
                TitleAndReveiw(widget: widget),
                // offer percentage & PreviousPrice
                Column(
                  children: [
                    Text(
                      _offerAvailable
                          ? '- ${percentageCount().toStringAsFixed(2)}%'
                          : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _offerAvailable ? widget.extra : '',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.black,
                          decorationColor: Colors.red,
                          fontSize: 22,
                          decorationThickness: 2.8),
                    )
                  ],
                ),
                //price
                PriceContainer(widget: widget),
              ],
            ),
          ),
          // description
          DescriptionWidget(widget: widget),
          // colors demo (circle)
          ColorDemo(),
          // choose color & size
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5, left: 35, bottom: 15, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.colorList[0] == "no"
                    ? Container()
                    : DropdownButton(
                        hint: Text(
                          'Choose Color',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        value: selectedColor,
                        items: widget.colorList.map((e) {
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
                            selectedColor = newVal;
                            sColor = 1;
                          });
                        }),
                widget.sizeList[0] == "no"
                    ? Container()
                    : DropdownButton(
                        hint: Text(
                          'Choose Size',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        value: selectedSize,
                        items: widget.sizeList.map((e) {
                          return DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.colorize),
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
                            selectedSize = newVal;
                            sSize = 1;
                          });
                        }),
              ],
            ),
          ),
          //offer coundown timer
          _offerAvailable ? CountDownClock(product: product) : Container(),
          // add_to_cart button
          AddToCartButton(
            cart: cart,
            widget: widget,
            size: size,
            selectedColor: selectedColor,
            selectedSize: selectedSize,
            sColor: sColor,
            sSize: sSize,
            fisrtColor: firstColor,
            firstSize: firstSize,
          ),
          // relatedProducts list
          RelatedProducts(widget._title, widget.category, widget.id),
          // comments
          InkWell(
            onTap: () {
              setState(() {
                _isComment = 0;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 80),
              width: double.infinity,
              color: Colors.black12,
              // comment section Row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Comments section',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  Icon(Icons.comment),
                ],
              ),
            ),
          ),
          _isComment != 1 ? Comments(widget.id, _comments) : Text(''),
        ],
      ),
    );
  }
}

class RelatedProducts extends StatelessWidget {
  final String name, cat, id;
  RelatedProducts(this.name, this.cat, this.id);
  List<Product> _relatedList = [];
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐';
    }
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    final load = Provider.of<Products>(context, listen: false);
    _relatedList = load.getRelatedProductsList(name, cat, id);
    return Container(
      height: 370,
      padding: EdgeInsets.all(15),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Related Products',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            height: 304.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: _relatedList[index].id,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 15,
                      child: Container(
                        color: Colors.indigo[200],
                        margin: EdgeInsets.all(10.0),
                        width: 210.0,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Positioned(
                              bottom: 5.0,
                              child: Container(
                                height: 100.0,
                                width: 200.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // price & offer Price Row
                                      Row(
                                        children: [
                                          Text(
                                            '\$ ${_relatedList[index].price}',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600,
                                                decoration: _relatedList[index]
                                                            .extra !=
                                                        "no"
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                                decorationThickness: 2,
                                                decorationColor: Colors.red),
                                          ),
                                          Spacer(),
                                          _relatedList[index].extra != "no"
                                              ? Text(
                                                  '\$ ${_relatedList[index].extra}',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                )
                                              : Text(''),
                                        ],
                                      ),
                                      // icon & Reviews
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on_sharp,
                                            size: 10.0,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 5.0),
                                          Text(
                                            '${_relatedList[index].isReview} activities',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ratings
                                      _buildRatingStars(
                                          _relatedList[index].isRating.toInt()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      _relatedList[index].imageUrl1,
                                      height: 180.0,
                                      width: 180.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    left: 5.0,
                                    bottom: 10.0,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _relatedList[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _relatedList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class PositionedWidget extends StatelessWidget {
  const PositionedWidget({
    Key key,
    @required this.size,
    @required this.widget,
  }) : super(key: key);

  final Size size;
  final ProductDetailScreenItem widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        height: size.height * .1,
        width: size.width * .55,
        decoration: BoxDecoration(
          color: Colors.lightGreen[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(63),
            bottomLeft: Radius.circular(63),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // current Ratings
            CurrentRating(widget: widget),
            // Ratings Bar
            RatingBar(widget: widget),
          ],
        ),
      ),
    );
  }
}

class CurrentRating extends StatelessWidget {
  const CurrentRating({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProductDetailScreenItem widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 3),
        Icon(
          Icons.star,
          color: Colors.red,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: '${widget.rating} /',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: '5\n',
                  style: TextStyle(
                    //fontSize: 16,
                    color: Colors.black,
                    //fontWeight: FontWeight.bold
                  )),
              TextSpan(
                  text: 'Ratings',
                  style: TextStyle(
                      //fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProductDetailScreenItem widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 3),
        SmoothStarRating(
          size: 26,
          borderColor: Colors.white,
          color: Colors.amber,
          spacing: 2.0,
          onRated: (value) {
            Provider.of<Products>(context, listen: false)
                .updateRatingAndReview(widget.id, value);
          },
        ),
        Text('Rate Us', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key key,
    @required this.cart,
    @required this.widget,
    @required this.size,
    @required this.selectedColor,
    @required this.selectedSize,
    @required this.sColor,
    @required this.sSize,
    @required this.fisrtColor,
    @required this.firstSize,
  }) : super(key: key);

  final Cart cart;
  final ProductDetailScreenItem widget;
  final Size size;
  final String selectedSize, selectedColor, fisrtColor, firstSize;
  final int sSize, sColor;

  @override
  Widget build(BuildContext context) {
    final double _currentPrice = widget.extra != "no" && widget.extra != "combo"
        ? double.parse(widget.extra)
        : widget.price;
    return InkWell(
      onTap: () => {
        if ((fisrtColor != "no" && sColor != 1) ||
            (firstSize != "no" && sSize != 1) ||
            ((fisrtColor != "no" && firstSize != "no") && sColor != 1 ||
                sSize != 1))
          {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Plzz select Color & Size..!'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.red,
            ))
          }
        else
          {
            cart.addItem(
              widget.id,
              _currentPrice,
              widget.image1,
              widget._title,
              1,
              selectedColor,
              selectedSize,
            ),
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Added item to Cart.!'),
              duration: Duration(seconds: 1),
            )),
          }
      },
      child: widget._available < 1
          ? ButtonOutOfStock(size: size)
          : ButtonAddToCart(size: size),
    );
  }
}

class ButtonOutOfStock extends StatelessWidget {
  const ButtonOutOfStock({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(20),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Out of Stock..!',
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationThickness: 2,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class ButtonAddToCart extends StatelessWidget {
  const ButtonAddToCart({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(20),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag),
          SizedBox(width: 10),
          Text(
            'Add  to  Cart',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceContainer extends StatelessWidget {
  const PriceContainer({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProductDetailScreenItem widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ClipPath(
        clipper: PriceCliper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15),
          height: 65,
          width: 74,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: Colors.amber[300],
          ),
          child: Text(
            '\$${widget.price.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.title.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class TitleAndReveiw extends StatelessWidget {
  const TitleAndReveiw({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProductDetailScreenItem widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            widget._title,
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
          ),
          Text(' ${widget.review} reviews'),
        ],
      ),
    );
  }
}

class CountDownClock extends StatelessWidget {
  const CountDownClock({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Products product;

  @override
  Widget build(BuildContext context) {
    return SlideCountdownClock(
      duration: Duration(minutes: product.deadLineDuration),
      padding: EdgeInsets.all(15),
      slideDirection: SlideDirection.Up,
      separator: ':',
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFC41A3B),
        shape: BoxShape.circle,
      ),
      shouldShowDays: true,
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProductDetailScreenItem widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE8F5E9).withOpacity(0.5),
      padding: EdgeInsets.all(10),
      child: Text(
        widget._description,
        style: TextStyle(height: 1.8),
      ),
    );
  }
}

class ColorDemo extends StatelessWidget {
  const ColorDemo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 35),
      height: 30,
      width: double.infinity,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ColorPin(c: Colors.cyan),
          ColorPin(c: Colors.purple),
          ColorPin(c: Colors.brown),
          ColorPin(c: Colors.red),
        ],
      ),
    );
  }
}

class PriceCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = 20;
    path.lineTo(0, size.height - height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipeer) {
    return true;
  }
}

class ColorPin extends StatelessWidget {
  final Color c;
  const ColorPin({
    this.c,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: () => ,
      child: Container(
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
      ),
    );
  }
}
