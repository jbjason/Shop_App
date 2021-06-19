import '../providers/product.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  All,
  Special_Offer,
  Combo_offer,
}

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';
  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  int _selectedIndex = 0;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  List<Product> get _selectedList {
    final productData = Provider.of<Products>(context);
    if (_selectedIndex == 0) {
      return productData.items;
    } else if (_selectedIndex == 1) {
      return productData.comboOfferItems;
    } else {
      return productData.specialOfferItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    final List<Product> productData = _selectedList;
    final name = ModalRoute.of(context).settings.arguments as String;
    bool _offerPage = (name == "specialOffer") ? true : false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Your Products',
            style: TextStyle(fontSize: 20, color: Colors.black87)),
        actions: [
          _offerPage
              ? PopupMenuButton(
                  onSelected: (FilterOptions value) {
                    setState(() {
                      if (value == FilterOptions.Special_Offer) {
                        _selectedIndex = 2;
                      } else if (value == FilterOptions.Combo_offer) {
                        _selectedIndex = 1;
                      } else {
                        _selectedIndex = 0;
                      }
                    });
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Special Offers'),
                      value: FilterOptions.Special_Offer,
                    ),
                    PopupMenuItem(
                      child: Text('Combo Offers'),
                      value: FilterOptions.Combo_offer,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ],
                )
              : IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName);
                  },
                ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(children: [
              UserProductItem(
                productData[i].id,
                productData[i].title,
                productData[i].imageUrl1,
                _offerPage,
              ),
            ]),
            itemCount: productData.length,
          ),
        ),
      ),
    );
  }
}
