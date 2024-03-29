import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFabs;
  ProductsGrid(this.showFabs);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  int selectedIndex = 0;

  final List<String> _category = [
    'All Products',
    'Favorites',
    'Electronics',
    'Sports',
    'Groceries',
    'Cloths'
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightOfScreen = MediaQuery.of(context).size.height;
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showFabs ? productsData.favoriteItems : productsData.items;

    return SingleChildScrollView(
      child: Column(
        children: [
          // SearchBar Container
          Container(
            height: 44,
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.only(right: 12, left: 12, top: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              style: TextStyle(color: Color(0xFF0277BD)),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                focusColor: Colors.white,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: 'Search a product',
                hintStyle: TextStyle(color: Color(0xFF00838F)),
              ),
            ),
          ),

          // Category Container
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: 20, right: index == _category.length - 1 ? 20 : 0),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? Colors.white.withOpacity(0.8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    _category[index],
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              itemCount: _category.length,
            ),
          ),

          // GridView Container
          Container(
            height: 380,
            margin: EdgeInsets.only(bottom: 5),
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                //create: (c) => products[i],
                value: products[i],
                child: ProductItem(
                    //products[i].id, products[i].title, products[i].imageUrl
                    ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
