import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnProductsListScreen extends StatefulWidget {
  static const routeName = '/return-products-list';
  @override
  _ReturnProductsListScreenState createState() =>
      _ReturnProductsListScreenState();
}

class _ReturnProductsListScreenState extends State<ReturnProductsListScreen> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        centerTitle: true,
        title: Text('Return Prod List'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchAndSetReturnList(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error occured !'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, product, _) => ListView.builder(
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(top: 25),
                    height: _expanded ? 280 : 100,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Text(
                              '${index + 1}.',
                              style: TextStyle(fontSize: 25),
                            ),
                            title: Text(
                                'OrderId: ${product.returnProducts[index].orderId}'),
                            subtitle:
                                Text('${product.returnProducts[index].email}'),
                            trailing: IconButton(
                              icon: Icon(_expanded
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                              onPressed: () {
                                setState(() {
                                  _expanded = !_expanded;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 15, left: 18, right: 5, bottom: 5),
                            height: _expanded ? 170 : 0,
                            child: ListView(
                              children: [
                                Text(
                                    'productId   :    ${product.returnProducts[index].productId} \n'),
                                Text(
                                    'contact       :    ${product.returnProducts[index].contact}\n'),
                                Text(
                                    'Address      :    ${product.returnProducts[index].address}\n'),
                                Text(
                                    'description :   ${product.returnProducts[index].description}\n'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  itemCount: product.returnProducts.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
