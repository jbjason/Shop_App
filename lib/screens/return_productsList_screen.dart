import 'package:Shop_App/models/returnClass.dart';
import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnProductsListScreen extends StatelessWidget {
  static const routeName = '/return-products-list';

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
              return Center(
                  child: Text('An error occured !\n No available Items'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, product, _) => ListView.builder(
                  itemBuilder: (context, index) =>
                      // this class exist in below
                      ReturnProductsListItem(
                          product.returnProducts[index], index),
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

class ReturnProductsListItem extends StatefulWidget {
  final ReturnClass returnItem;
  final int index;
  ReturnProductsListItem(this.returnItem, this.index);

  @override
  _ReturnProductsListItemState createState() => _ReturnProductsListItemState();
}

class _ReturnProductsListItemState extends State<ReturnProductsListItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: 25),
      height: _expanded ? 280 : 100,
      child: Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Text(
                '${widget.index + 1}.',
                style: TextStyle(fontSize: 25),
              ),
              title: Text(
                'OrderId: ${widget.returnItem.orderId}',
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              subtitle: Text('${widget.returnItem.email}'),
              trailing: Container(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        try {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Alert !'),
                              content: Text('Do you want to remove the item?'),
                              actions: [
                                FlatButton(
                                  onPressed: () async {
                                    await order.deleteReturnListItem(
                                        widget.returnItem.id);
                                  },
                                  child: Text('Yes'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            ),
                          );
                        } catch (error) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleteing Failed'),
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15, left: 18, right: 5, bottom: 5),
              height: _expanded ? 170 : 0,
              child: ListView(
                children: [
                  Text('productId   :    ${widget.returnItem.productId} \n'),
                  Text('contact       :    ${widget.returnItem.contact}\n'),
                  Text('Address      :    ${widget.returnItem.address}\n'),
                  Text('description :   ${widget.returnItem.description}\n'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
