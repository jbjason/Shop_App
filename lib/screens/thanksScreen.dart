import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/orders.dart';
import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ThanksScreen extends StatelessWidget {
  final String name, address, contact;
  final double finalAmount, finalVoucher;
  final int finalPoint;
  final List<CartItem> finalProduct;
  ThanksScreen(this.finalProduct, this.finalPoint, this.finalVoucher,
      this.finalAmount, this.name, this.address, this.contact);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    final String orderId =
        Provider.of<Orders>(context, listen: false).customerOrderId;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            SuccessFullText(),
            InvoiceTitleAndOrderId(orderId: orderId),
            UserInfoDetails(
                size: size, name: name, address: address, contact: contact),
            TitlePriceAsTitleText(),
            ProductsDetails(finalProduct: finalProduct),
            SubTotalOfferAmount(
                finalAmount: finalAmount,
                finalPoint: finalPoint,
                finalVoucher: finalVoucher),
            SizedBox(height: 15),
            GoBackButton(finalProduct: finalProduct),
          ],
        ),
      ),
    );
  }
}

class ProductsDetails extends StatelessWidget {
  const ProductsDetails({
    Key key,
    @required this.finalProduct,
  }) : super(key: key);

  final List<CartItem> finalProduct;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(5),
        height: finalProduct.length * 24.0 + 7,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: finalProduct
              .map((prod) => Row(
                    children: [
                      SizedBox(width: 3),
                      Text('${prod.title}', overflow: TextOverflow.fade),
                      Spacer(),
                      Text('${prod.quantity}x  \$${prod.price}'),
                      SizedBox(width: 3),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class TitlePriceAsTitleText extends StatelessWidget {
  const TitlePriceAsTitleText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20),
        Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
        Spacer(),
        Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 12),
        Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class SuccessFullText extends StatelessWidget {
  const SuccessFullText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      height: 30,
      child: Text(
        'Your order has been placed successfully !',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SubTotalOfferAmount extends StatelessWidget {
  const SubTotalOfferAmount({
    Key key,
    @required this.finalAmount,
    @required this.finalPoint,
    @required this.finalVoucher,
  }) : super(key: key);

  final double finalAmount;
  final int finalPoint;
  final double finalVoucher;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Sub Total : \$ $finalAmount\n\n',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                    fontSize: 16)),
            TextSpan(
                text: 'Discount : \$ ${finalPoint + finalVoucher}\n\n',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                    fontSize: 16)),
            TextSpan(
                text:
                    'Grand Total : \$ ${finalAmount - (finalPoint + finalVoucher)}\n\n',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                    decorationThickness: 2.3,
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
      ],
    );
  }
}

class UserInfoDetails extends StatelessWidget {
  const UserInfoDetails({
    Key key,
    @required this.size,
    @required this.name,
    @required this.address,
    @required this.contact,
  }) : super(key: key);

  final Size size;
  final String name;
  final String address;
  final String contact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: size.width * 8,
              child: Text(
                'Bill TO : ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(width: 70, child: Text('Name :')),
                Text('$name',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
    );
  }
}

class InvoiceTitleAndOrderId extends StatelessWidget {
  const InvoiceTitleAndOrderId({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.black26,
      child: Row(
        children: [
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('INVOICE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('OrderId :'),
                  Text('$orderId'),
                ],
              ),
              Row(children: [
                Text('Date : '),
                Text(DateFormat('dd-mm -yyyy').format(DateTime.now())),
              ]),
            ],
          )
        ],
      ),
    );
  }
}

class GoBackButton extends StatefulWidget {
  const GoBackButton({
    Key key,
    @required this.finalProduct,
  }) : super(key: key);
  final List<CartItem> finalProduct;
  @override
  _GoBackButtonState createState() => _GoBackButtonState();
}

class _GoBackButtonState extends State<GoBackButton> {
  var _isInit = true;

  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .updateAvailableProduct(widget.finalProduct)
        .then((_) {
      setState(() {
        _isInit = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.green[100], boxShadow: [
              BoxShadow(
                offset: Offset(5, 3),
                blurRadius: 10,
                color: Colors.greenAccent,
              ),
            ]),
            child: Row(
              children: [
                Text('Order Processing...'),
                CircularProgressIndicator(backgroundColor: Colors.purple),
              ],
            ),
          )
        : InkWell(
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
                  Icon(Icons.arrow_circle_up_sharp),
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
