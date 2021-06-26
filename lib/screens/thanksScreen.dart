import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ThanksScreen extends StatelessWidget {
  static const routeName = '/thanks-screen';
  final String name, address, contact;
  final double finalAmount, finalVoucher;
  final int finalPoint;
  final List<CartItem> finalProduct;
  ThanksScreen(this.finalProduct, this.finalPoint, this.finalVoucher,
      this.finalAmount, this.name, this.address, this.contact);
  @override
  Widget build(BuildContext context) {
    final String orderId =
        Provider.of<Orders>(context, listen: false).customerOrderId;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                color: Colors.pink,
                child: Text(
                  'Your order has been placed successfully',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Text(finalProduct[0].price.toString()),
              Text(finalProduct[0].title),
              Text(finalProduct[0].quantity.toString()),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.only(bottom: 30),
                color: Colors.black26,
                child: Row(
                  children: [
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('INVOICE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('OrderId :'),
                            Text('$orderId'),
                          ],
                        ),
                        Row(children: [
                          Text('Date : '),
                          Text(
                              DateFormat('dd-mm -yyyy').format(DateTime.now())),
                        ]),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: size.width * 8,
                        child: Text(
                          'Bill TO : ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(width: 70, child: Text('Name :')),
                          Text('$name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(width: 70, child: Text('Address :')),
                          Container(
                            width: 280,
                            child: Text(address,
                                //overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(width: 70, child: Text('Contact :')),
                          Text(contact, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        '* Estimated Delivary in 7days *',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: length * 22.0 + 10,
              //   child: ListView(
              //     physics: NeverScrollableScrollPhysics(),
              //     children: widget.order.products
              //         .map((prod) => Row(
              //               children: [
              //                 Text(
              //                   '${prod.title}',
              //                   overflow: TextOverflow.fade,
              //                   style: TextStyle(
              //                       fontSize: 18, fontWeight: FontWeight.bold),
              //                 ),
              //                 Spacer(),
              //                 Text(
              //                   '${prod.quantity}x  \$${prod.price}',
              //                   style: TextStyle(
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ],
              //             ))
              //         .toList(),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '    Sub Total : \$ $finalAmount\n\n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 20)),
                      TextSpan(
                          text:
                              '    Discount : \$ ${finalPoint + finalVoucher}\n\n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 20)),
                      TextSpan(
                          text:
                              '    Grand Total : \$ ${finalAmount - (finalPoint + finalVoucher)}\n\n',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
              ),
              SizedBox(height: 15),
              GoBackButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // for popping 2page at a time
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 3;
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.green[100], boxShadow: [
          BoxShadow(
            offset: Offset(5, 3),
            blurRadius: 10,
            color: Colors.greenAccent,
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset(
                'assets/images/back_arrow_1.jpg',
                fit: BoxFit.fill,
                height: 32,
              ),
            ),
            SizedBox(width: 14),
            SizedBox(child: Text('|')),
            SizedBox(width: 20),
            Text(
              ' Back to the Shop ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
