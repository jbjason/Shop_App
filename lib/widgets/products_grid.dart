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
  int selectedIndex = 0, _isInit = 0;
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

  final List<String> _cities = [];
  void setCitiesData() {
    final productsDat = Provider.of<Products>(context, listen: false).items;
    if (_isInit != 0) return;
    int n = productsDat.length;
    for (int i = 0; i < n; i++) {
      _cities.insert(i, productsDat[i].title);
    }
    setState(() {
      _isInit++;
    });
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Color(0xFF0277BD)),
                    textInputAction: TextInputAction.done,
                    readOnly: true,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: 'Search a product',
                      hintStyle: TextStyle(color: Color(0xFF00838F)),
                    ),
                    onTap: () async {
                      setCitiesData();
                      final result = await showSearch(
                          context: context, delegate: DataSearch(_cities));
                      print(result);
                    },
                  ),
                ),
              ],
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
                value: products[i],
                child: ProductItem(
                    //products[i].id, products[i].title, products[i].imageUrl
                    ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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

class DataSearch extends SearchDelegate<String> {
  final List<String> cities;
  DataSearch(this.cities);
  final recentCities = [
    "London",
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
          : cities.where((p) {
              final cityLower = p.toLowerCase();
              final queryLower = query.toLowerCase();
              return cityLower.startsWith(queryLower);
            }).toList();
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionList[index];
            print('jb');
            close(context, query);
            //showResults(context);
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
