import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as pi;
import 'dart:math';

class OrderItem extends StatefulWidget {
  final pi.OrderItem order;
  final int index;
  OrderItem(this.order, this.index);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 10),
      height: _expanded ? 250 : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Column(
          children: [
            ListTile(
              leading: Text(
                '${widget.index + 1}.',
                style: TextStyle(fontSize: 24),
              ),
              isThreeLine: true,
              title: Text('Total =  \$ ${widget.order.amount}'),
              subtitle: RichText(
                softWrap: true,
                text: TextSpan(children: [
                  WidgetSpan(
                    child: FlatButton.icon(
                        onPressed: () {},
                        color: Colors.amber[100],
                        icon: Icon(Icons.arrow_circle_down),
                        label: Text('Pending')),
                  ),
                ]),
              ),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? 120 : 0,
              child: ListView(
                children: [
                  Text(
                    'Date   :    ' +
                        DateFormat('dd/MM/yyyy   hh:mm\n')
                            .format(widget.order.dateTime),
                  ),
                  Container(
                    height: widget.order.products.length * 22.0 + 10,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: widget.order.products
                          .map((prod) => Row(
                                children: [
                                  Text(
                                    '${prod.title}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${prod.quantity}x  \$${prod.price}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
