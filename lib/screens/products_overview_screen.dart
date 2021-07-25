import 'package:Shop_App/providers/product.dart';
import 'package:Shop_App/screens/offers_scrren.dart';
import 'package:Shop_App/screens/product_detail_screen.dart';
import '../widgets/product_item.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:flutter/services.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routename = '/products-overview-screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  int currentNavigateIndex = 0, selectedIndex = 0;
  bool _isLoading = true, _isInit = true, isDrawerOpen = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isCategory = false, _isSearch = false;
  double xOffset = 0, yOffset = 0;

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  void didChangeDependencies() {
    if (_isInit == false) return;
    //Provider.of<Products>(context, listen: false).fetchAndSetDeadLines();
    Provider.of<Products>(context, listen: false)
      ..fetchOffersImagesList().then((_) {
        Provider.of<Products>(context, listen: false).fetchAndSetDeadLines();
        setState(() {
          _isLoading = false;
          _isInit = false;
        });
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    final size = MediaQuery.of(context).size;
    final productsData = Provider.of<Products>(context);
    final offerPic = Provider.of<Products>(context).offersImages;
    final List<String> _category = productsData.categories;
    final products = currentNavigateIndex == 1
        ? productsData.favoriteItems
        : _isCategory
            ? productsData.getSelectedCategoryList
            : _isSearch
                ? productsData.getSearchedList
                : productsData.items;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        AppDrawer(),
        AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(isDrawerOpen ? 0.85 : 1.00)
            ..rotateZ(isDrawerOpen ? -50 : 0),
          duration: Duration(milliseconds: 200),
          color: Colors.white,
          child: Stack(
            children: [
              YellowDesignForHome(size: size),
              Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(13),
                    child: ListView(shrinkWrap: true, children: [
                      // drawer & cartIcon
                      Row(children: [
                        isDrawerOpen
                            ? GestureDetector(
                                child: Icon(Icons.arrow_back_ios),
                                onTap: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    isDrawerOpen = false;
                                  });
                                },
                              )
                            : IconButton(
                                alignment: Alignment.topLeft,
                                icon: Icon(
                                  Icons.menu,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    xOffset = 290;
                                    yOffset = 80;
                                    isDrawerOpen = true;
                                  });
                                }),
                        Spacer(),
                        Consumer<Cart>(
                          builder: (_, cart, ch) => Badge(
                              child: ch, value: cart.itemCount.toString()),
                          child: IconButton(
                            //alignment: Alignment.topRight,
                            icon: Icon(
                              Icons.shopping_cart,
                              size: 26,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(CartScreen.routeName);
                            },
                          ),
                        ),
                      ]),
                      Container(
                        height: size.height * .1,
                        child: Row(
                          children: [
                            SizedBox(width: 5.0),
                            Container(
                              alignment: Alignment.topLeft,
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2.0),
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/pinch2.png',
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              ' Hii there..!',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // what u like Text
                      Container(
                        height: size.height * .03,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'What do You Like to Buy ?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              wordSpacing: 5,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      // SearchBar
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Material(
                          elevation: 7.0,
                          borderRadius: BorderRadius.circular(5.0),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search,
                                    color: Color(getColorHexFromStr('#FEDF62')),
                                    size: 30.0),
                                contentPadding:
                                    EdgeInsets.only(left: 15.0, top: 15.0),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand')),
                            onTap: () async {
                              final result = await showSearch(
                                  context: context,
                                  delegate:
                                      DataSearch(productsData.searcHints));
                              if (result != null) {
                                setState(() {
                                  productsData.setSerachForProduct(result);
                                  _isSearch = true;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      //OfferPic
                      offerPic.length == 0
                          ? Container(height: 15)
                          : InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(OffersScreen.routeName);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                height: 230,
                                width: size.width * .7,
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : Image.asset(
                                        'assets/images/offPic.png',
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                      // category List
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                productsData
                                    .setSelectedCategoryIndex(selectedIndex);
                                _isCategory = true;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 3,
                                  right:
                                      index == _category.length - 1 ? 20 : 20),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                color: index == selectedIndex
                                    ? Color(0xFFFEE16D)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Row(children: [
                                Icon(
                                  Icons.donut_small_sharp,
                                  color: Colors.black12,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  _category[index],
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                          ),
                          itemCount: _category.length,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Popular',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold),
                      ),
                      PopularProducts(productsData.getPopularProducts),
                      Text(
                        'Reccomended For You',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: products.length * 195.0,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                          itemBuilder: (BuildContext ctx, int index) =>
                              ProductItem(products[index]),
                          itemCount: products.length,
                        ),
                      ),
                      SizedBox(height: 20),
                    ]),
                  )),
                ],
              ),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavigateIndex,
        iconSize: 16,
        selectedFontSize: 18,
        unselectedFontSize: 13,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
        backgroundColor: Color(0xFFFDD34A).withOpacity(0.1),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'All'),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentNavigateIndex = index;
          });
        },
      ),
    );
  }
}

class YellowDesignForHome extends StatelessWidget {
  const YellowDesignForHome({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .26,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xFFFDD148),
        borderRadius: BorderRadius.only(
          //bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(180.0),
        ),
      ),
      child: Stack(children: [
        Positioned(
          right: size.width * .4,
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
          bottom: 10.0,
          left: size.width * .4,
          child: Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Color(0xFFFEE16D).withOpacity(0.5))),
        ),
        Positioned(
          bottom: size.height * .13,
          left: size.width * .1,
          child: Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Color(0xFFFDD148).withOpacity(0.7))),
        ),
      ]),
    );
  }
}

class PopularProducts extends StatelessWidget {
  // final String name, cat, id;
  final List<Product> _relatedList;
  PopularProducts(this._relatedList);
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐';
    }
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: EdgeInsets.only(bottom: 15, left: 5, right: 5),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
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
                      elevation: 3,
                      child: Container(
                        //color: Color(0xFFFDD148).withOpacity(0.7),
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
                                  color: Color(0xFFFDD148).withOpacity(0.3),
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
                                            '${11} activities',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ratings
                                      _buildRatingStars(5),
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

class DataSearch extends SearchDelegate<String> {
  final List<String> _hints;
  DataSearch(this._hints);
  final recentCities = [
    "Red T-shirt",
    "Munich",
    "Paris",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    try {
      return [
        IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              query = "";
            })
      ];
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    try {
      return IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            close(context, null);
          });
    } catch (error) {
      throw UnimplementedError();
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    //return
    return Center(
      child: Text(
        query,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    try {
      final suggestionList = query.isEmpty
          ? recentCities
          : _hints.where((p) {
              final cityLower = p.toLowerCase();
              final queryLower = query.toLowerCase();
              return cityLower.startsWith(queryLower);
            }).toList();
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionList[index];
            close(context, query);
          },
          leading: Icon(Icons.location_city),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
        itemCount: suggestionList.length,
      );
    } catch (error) {
      throw UnimplementedError();
    }
  }
}
