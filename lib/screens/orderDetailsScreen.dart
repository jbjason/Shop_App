import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/orders.dart';
import 'package:Shop_App/screens/thanksScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/orderDetailsScreen';
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _form = GlobalKey<FormState>();
  final _numberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _detailsFocusNode = FocusNode();
  final _voucherFocusNode = FocusNode();
  bool _isInit = false;
  var _isLoading = false, _isVoucherYes = false;
  Map<String, String> _info = {
    'name': '',
    'email': '',
    'contact': '',
    'details': '',
  };
  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).fetchPoint();
    super.initState();
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _emailFocusNode.dispose();
    _detailsFocusNode.dispose();
    _voucherFocusNode.dispose();
    super.dispose();
  }

  Future<void> submit(int point) async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    final cart = Provider.of<Cart>(context, listen: false);
    double amount = cart.totalAmount;
    double cutAmount;
    if (point >= amount) {
      cutAmount = point - amount;
      point = cutAmount.toInt();
    } else {
      cutAmount = amount - point;
      point = 1;
    }
    String totalCartItems = cart.itemCount.toString();
    await Provider.of<Orders>(context, listen: false).customerOrdersOnServer(
      _info['name'],
      _info['email'],
      _info['contact'],
      _info['details'],
      cart.items.values.toList(),
      _isVoucherYes ? cutAmount : amount,
    );
    await Provider.of<Orders>(context, listen: false)
        .addOrder(cart.items.values.toList(), amount);
    await Provider.of<Orders>(context, listen: false)
        .addBonusPoint(amount, point)
        .then((value) => cart.clear());
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed(ThanksScreen.routeName,
        arguments: [totalCartItems, _info['details']]);
  }

  Widget pointBar(int p) {
    if (p == 0 || p == null) p = 2;
    RangeValues values = RangeValues(0, p.toDouble());
    return RangeSlider(
      values: values,
      min: 0,
      max: 100,
      divisions: 50,
      labels: RangeLabels(
        values.start.round().toString(),
        values.end.round().toString(),
      ),
      onChanged: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final fp = Provider.of<Orders>(context, listen: false).pointt;
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm ur details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                // name
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name !';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['name'] = value;
                  },
                ),
                // email
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email-address'),
                  focusNode: _emailFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_numberFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a email-address !';
                    } else if (!value.contains('@') ||
                        !value.contains('.com')) {
                      return 'Invalid email-adrress';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['email'] = value;
                  },
                ),
                //contact no
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact number'),
                  focusNode: _numberFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_detailsFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a contact number !';
                    } else if (value.length < 11) {
                      return 'Should be at least 11 characters';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['contact'] = value;
                  },
                ),
                //details
                TextFormField(
                  decoration: InputDecoration(labelText: 'Details address'),
                  focusNode: _detailsFocusNode,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide full address !';
                    } else if (value.length < 11) {
                      return 'Should be at least 10 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['details'] = value;
                  },
                ),
                SizedBox(height: 40),
                Text('Your Bonus Points',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                // pointBar
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: pointBar(fp),
                ),
                //voucher code
                Container(
                  height: 40,
                  width: 80,
                  //padding: EdgeInsets.all(20),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('Voucher code:   '),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '     Y / N',
                        ),
                        onSaved: (value) {
                          if (value == "y" || value == "Y") {
                            setState(() {
                              _isVoucherYes = true;
                            });
                          }
                        },
                      ),
                    )
                  ]),
                ),
                SizedBox(height: 20),
                RaisedButton.icon(
                  color: Colors.amber[200],
                  onPressed: () {
                    setState(() {
                      _isInit = true;
                    });
                  },
                  icon: Icon(Icons.shopping_bag),
                  label: Text('Comit to purchase'),
                ),
                _isInit == false ? Icon(null) : TermsAndCondition(),
                _isInit == false
                    ? Icon(null)
                    : Container(
                        padding: EdgeInsets.all(6),
                        width: double.infinity,
                        color: Colors.lightGreen[50],
                        child: RaisedButton(
                            onPressed: () => submit(fp),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.pink,
                                  )
                                : Text(
                                    'Confirm Order',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.red),
                                  )),
                      ),
                // FlatButton(
                //   onPressed: () => submit(fp),
                //   child: _isLoading
                //       ? CircularProgressIndicator(
                //           backgroundColor: Colors.pink,
                //         )
                //       : Text('Commit to purchase'),
                //   textColor: Colors.green,
                // ),
              ],
            )),
      ),
    );
  }
}

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: double.infinity,
      child: Card(
        color: Colors.blueGrey[900],
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: ' Terms & Conditions\n\n\n',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text:
                  '   Delivery of the product will be completed within approximately 7 working days.\n\n'),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text: '   Delivered products can be returned within 7 days.\n\n'),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text:
                  '   You can return or compain by filling up the form from your profile page.\n\n'),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(text: '    Vat won\'t be included.\n\n'),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(text: '   Delivery charge ${35}.tk will be included.\n\n\n'),
          TextSpan(text: '  Shipping Method  :   '),
          WidgetSpan(
              child: Icon(Icons.car_rental, size: 24, color: Colors.white)),
          TextSpan(text: '\n\n  Payment Method  :   '),
          WidgetSpan(child: Icon(Icons.money, size: 24, color: Colors.white)),
          TextSpan(text: '  ( cash in Delivery )\n\n\n'),
          TextSpan(
              text: ' I agree to the Terms & Conditions...\n\n',
              style: TextStyle(fontSize: 18, color: Colors.lightGreen[200])),
        ])),
      ),
    );
  }
}
