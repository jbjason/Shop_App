import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
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
  // var _showOnlyFavorites = false;
  int currentNavigateIndex = 0;
  bool _isLoading = true, _isInit = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   Provider.of<Products>(context, listen: false).fetchAndSetDeadLines();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit == false) return;
    //Provider.of<Products>(context, listen: false).fetchAndSetDeadLines();
    Provider.of<Products>(context)
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
      statusBarColor: Color(0xFFFDD148),
      statusBarBrightness: Brightness.light,
    ));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      // Appbar Styling with image
      // backgroundColor: Color(0xFFC8E6C9),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(45),
      //   child: AppBar(
      //     backgroundColor: Color(0xFFC8E6C9),
      //     centerTitle: true,
      //     title: Row(
      //       children: [
      //         Text(
      //           'MY ',
      //           style: TextStyle(
      //               color: Colors.black87,
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold),
      //         ),
      //         Image.asset('assets/images/pinch2.png'),
      //         Text(' SHOP',
      //             style: TextStyle(
      //                 color: Colors.black87,
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.bold)),
      //       ],
      //     ),
      //     actions: [
      // PopupMenuButton(
      //   onSelected: (FilterOptions selectedValue) {
      //     setState(() {
      //       if (selectedValue == FilterOptions.Favorites) {
      //         _showOnlyFavorites = true;
      //       } else {
      //         _showOnlyFavorites = false;
      //       }
      //     });
      //   },
      //   icon: Icon(Icons.more_vert),
      //   itemBuilder: (_) => [
      //     PopupMenuItem(
      //       child: Text('Only Favorites'),
      //       value: FilterOptions.Favorites,
      //     ),
      //     PopupMenuItem(
      //       child: Text('Show All'),
      //       value: FilterOptions.All,
      //     ),
      //   ],
      // ),
      // Consumer<Cart>(
      //   builder: (_, cart, ch) =>
      //       Badge(child: ch, value: cart.itemCount.toString()),
      //   child: IconButton(
      //     icon: Icon(Icons.shopping_cart),
      //     onPressed: () {
      //       Navigator.of(context).pushNamed(CartScreen.routeName);
      //     },
      //   ),
      // ),
      //     ],
      //   ),
      // ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          YellowDesignForHome(size: size),
          Positioned(
            top: size.height * .04,
            left: 10,
            child: IconButton(
              alignment: Alignment.topLeft,
              icon: Icon(Icons.menu, size: 20),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
          ),
          Positioned(
            top: size.height * .04,
            right: 20,
            child: Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                alignment: Alignment.topRight,
                icon: Icon(
                  Icons.shopping_basket,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
          ProductsGrid(currentNavigateIndex == 0 ? false : true, _isLoading),
        ],
      ),
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
