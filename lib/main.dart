import './screens/offers_scrren.dart';
import './screens/confirm_orders_screen.dart';
import './screens/return_productsList_screen.dart';
import './screens/orderDetailsScreen.dart';
import 'screens/return_productForm_screen.dart';
import './screens/suggestion_Report_Screen.dart';
import './screens/thanksScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
            //create: (ctx) => Products(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            // previousProducts null hole Empty_array[] pass kortesi
            update: (ctx, auth, previousProducts) => Orders(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            debugShowCheckedModeBanner: false,
            home: authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              OrderDetailsScreen.routeName: (ctx) => OrderDetailsScreen(),
              ThanksScreen.routeName: (ctx) => ThanksScreen(),
              SuggestionReportScreen.routeName: (ctx) =>
                  SuggestionReportScreen(),
              // this is the Return_productForm_scree
              ReturnProductScreen.routeName: (ctx) => ReturnProductScreen(),
              ReturnProductsListScreen.routeName: (ctx) =>
                  ReturnProductsListScreen(),
              ConfirmOrdersScreen.routeName: (ctx) => ConfirmOrdersScreen(),
              OffersScreen.routeName: (ctx) => OffersScreen(),
            },
          ),
        ));
  }
}
