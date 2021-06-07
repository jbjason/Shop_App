import '../models/confirmOrdersClass.dart';
import '../providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmOrdersScreen extends StatelessWidget {
  static const routeName = '/confirm-orders-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Customer Orders',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetConfiremOrders(),
          builder: (ctx, dataSnapShot) {
            if (ConnectionState.waiting == dataSnapShot.connectionState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Orders>(
                builder: (ctx, product, _) => ListView.builder(
                  itemBuilder: (context, index) =>
                      CustomerOrdersItem(product.customerOrders[index], index),
                  itemCount: product.customerOrders.length,
                ),
              );
            }
          }),
    );
  }
}

class CustomerOrdersItem extends StatefulWidget {
  final ConfirmOrdersClass _order;
  final int index;
  CustomerOrdersItem(this._order, this.index);
  @override
  _CustomerOrdersItemState createState() => _CustomerOrdersItemState();
}

class _CustomerOrdersItemState extends State<CustomerOrdersItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
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
              title: Text('OrderId: ${widget._order.orderId}'),
              subtitle: Text('${widget._order.email}'),
              trailing: Container(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          // await order.deleteReturnListItem(
                          //     widget.returnItem[widget.index].id);
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
              height: _expanded ? 200 : 0,
              child: ListView(
                children: [
                  Text('OrderId   :    ${widget._order.orderId}\n'),
                  Text('Name   :    ${widget._order.name} \n'),
                  Text('contact  :    ${widget._order.contact}\n'),
                  Text('Address      :    ${widget._order.address}\n'),
                  Text('total Amount :   ${widget._order.amount}\n'),
                  Text('Products  :'),
                  // Container(
                  //   height: widget._order.cartProducts.length*20.0 + 10,
                  //   child: ListView(
                  //     children: widget._order.cartProducts.map((e) => ,),
                  //     ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
