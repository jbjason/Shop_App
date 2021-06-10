import 'package:flutter/material.dart';
import '../providers/orders.dart' as pi;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final pi.OrderItem order;
  OrderItem(this.order);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('Total =  \$${widget.order.amount}'),
              subtitle: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: FlatButton.icon(
                        onPressed: () {},
                        color: Colors.amber[100],
                        icon: Icon(Icons.arrow_circle_down),
                        label: Text('Pending')),
                  ),
                  TextSpan(
                      text: DateFormat('dd/MM/yyyy hh:mm')
                          .format(widget.order.dateTime)),
                ]),
              ),

              // Text(
              //   DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              // ),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          children: [
                            Text(
                              '${prod.title}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
            )
          ],
        ),
      ),
    );
  }
}
