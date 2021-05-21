import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:Shop_App/widgets/comments.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ProductDetailScreenItem extends StatefulWidget {
  final String image1 =
      'https://www.onlygfx.com/wp-content/uploads/2015/12/old-paper-cover.jpg';
  final String image2 =
      'https://images-na.ssl-images-amazon.com/images/I/51c%2BT7XynwL._AC_UX679_.jpg';
  final String image3 =
      'https://i.pinimg.com/474x/e4/ed/45/e4ed45ddf937abb7c3862469a15372c8.jpg';
  String currentImageUrl;
  int _isInit = 1;
  @override
  _ProductDetailScreenItemState createState() =>
      _ProductDetailScreenItemState();
}

class _ProductDetailScreenItemState extends State<ProductDetailScreenItem> {
  final primaryColor = Color(0xFF0C9869);
  final backgroundColor = Color(0xFFF9F8FD);
  List<String> _locations = ['M', 'L', 'XL', 'XXL'];
  String _selectedLocation;
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
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
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
                    //margin: EdgeInsets.only(bottom: 120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          //alignment: Alignment.topLeft,
                          child: IconButton(
                              icon: Icon(Icons.arrow_back), onPressed: () {}),
                        ),
                        //SizedBox(height: 30),
                        _iconWidget(widget.image1),
                        _iconWidget(widget.image2),
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: size.height * .1,
                            width: size.width * .55,
                            // color: Colors.amber,
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
                                Column(
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
                                              text: '4.5 /',
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
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 3),
                                    SmoothStarRating(
                                      size: 26,
                                      borderColor: Colors.white,
                                      color: Colors.amber,
                                      spacing: 2.0,
                                      //rating: ratingg,
                                      // onRated: (value) {
                                      //   ratingg = (ratingg + value) / 2;
                                      // },
                                    ),
                                    Text('Rate Us',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Color(0xFFE8F5E9).withOpacity(0.5),
            margin: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Angelica',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                      ),
                      Text(': 112 reviews'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: ClipPath(
                    clipper: PriceCliper(),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      height: 65,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        color: Colors.amber[300],
                      ),
                      child: Text(
                        '\$${450}',
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFFE8F5E9).withOpacity(0.5),
            padding: EdgeInsets.all(10),
            child: Text(
              'this jhsdgjshdj ghjsd  jdfgh jdfh jhd iuuyoier yor porpuporpu prt ur tluklr tjuklrtuoru  5kuyjeru .this jhsdgjshdj ghjsd  jdfgh jdfh jhd iuuyoier yor porpuporpu prt ur tluklr tjuklrtuoru  5kuyjeru..\n Jb Jb Jb ',
              style: TextStyle(height: 1.8),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.1),
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
          ),
          Container(
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
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5, left: 35, bottom: 15, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                    hint: Text(
                      'Choose Color',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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
                DropdownButton(
                    hint: Text(
                      'Choose Size',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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
          ),
          Comments(),
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
