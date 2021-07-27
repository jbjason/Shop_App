import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/products.dart';
import 'thanksScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/orderDetailsScreen';
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _form = GlobalKey<FormState>(),
      _voucherFocusNode = FocusNode(),
      _numberFocusNode = FocusNode(),
      _emailFocusNode = FocusNode(),
      _addressFocusNode = FocusNode(),
      _userPointsFocusNode = FocusNode(),
      _voucherController = TextEditingController(),
      _emailController = TextEditingController(),
      _nameController = TextEditingController(),
      _contactController = TextEditingController(),
      _addressController = TextEditingController();
  bool _isInit = false, _isLoading = false, _isUsePointsYes = false;
  bool _isVoucherCodeOk = false, _isfetching = true;
  String name, email, address, contact;
  int _voucherIndex, k = 0;

  @override
  void didChangeDependencies() {
    if (k != 0) return;
    Provider.of<Products>(context, listen: false).fetchOffersUptoAmount();
    Provider.of<Orders>(context, listen: false).fetchPoint().then((_) {
      setState(() {
        _isfetching = false;
      });
    });
    k++;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    _userPointsFocusNode.dispose();
    _voucherController.dispose();
    _voucherFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> submit(int point) async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final userLocalId = Provider.of<Auth>(context, listen: false).userId;
    final cart = Provider.of<Cart>(context, listen: false);
    // this three for sending to ThanksScreen
    double finalAmount, finalVoucher = 0;
    int finalPoint = 0;
    final List<CartItem> allCartProducts = cart.items.values.toList();
    // amount,Bonus smaller & bigger conflict solve
    double cutAmount = cart.totalAmount;
    finalAmount = cutAmount;
    if (_isUsePointsYes) {
      if (point >= cutAmount) {
        finalPoint = cutAmount.toInt();
        cutAmount = point - cutAmount;
        point = cutAmount.toInt();
      } else {
        cutAmount = cutAmount - point;
        finalPoint = point;
        point = 2;
      }
    }
    if (_isVoucherCodeOk) {
      final double s = Provider.of<Products>(context, listen: false)
          .uptoOffersList[_voucherIndex]
          .rewardPoint;
      cutAmount -= s;
      finalVoucher = s;
    }
    email = _emailController.text.trim();
    name = _nameController.text.trim();
    contact = _contactController.text.trim();
    address = _addressController.text.trim();
    await Provider.of<Orders>(context, listen: false)
        .addOrder(allCartProducts, cutAmount)
        .then((_) {
      Provider.of<Orders>(context, listen: false).addCustomerOrdersOnServer(
        name,
        email,
        contact,
        address,
        allCartProducts,
        cutAmount,
        userLocalId,
      );
    });
    await Provider.of<Orders>(context, listen: false)
        .addBonusPoint(cart.totalAmount, point)
        .then((value) => cart.clear());
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ThanksScreen(allCartProducts, finalPoint,
          finalVoucher, finalAmount, name, address, contact),
    ));
  }

  void checkingVoucher(String _voucherText) {
    final s = Provider.of<Products>(context, listen: false).uptoOffersList;
    int i = 0;
    s.forEach((element) {
      if (element.voucherCode == _voucherText) {
        setState(() {
          _isVoucherCodeOk = true;
          _voucherIndex = i;
          return;
        });
      }
      i++;
    });
    if (!_isVoucherCodeOk) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Wrong code !')));
    }
  }

  Widget pointBar(int p) {
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFDD148),
      statusBarBrightness: Brightness.light,
    ));
    final size = MediaQuery.of(context).size;
    final fp = Provider.of<Orders>(context).pointt;
    return Scaffold(
      key: _scaffoldKey,
      body: _isfetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              YellowDesign(size),
              Column(children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: ListView(
                        children: [
                          IconButton(
                              alignment: Alignment.topLeft,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          Text(
                            ' Confirm Orders',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 64),
                          // name
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            textInputAction: TextInputAction.next,
                            controller: _nameController,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a name !';
                              }
                              return null;
                            },
                          ),
                          // email
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Email-address'),
                            focusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_numberFocusNode);
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
                          ),
                          //contact no
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Contact number'),
                            focusNode: _numberFocusNode,
                            textInputAction: TextInputAction.next,
                            controller: _contactController,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_addressFocusNode);
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
                          ),
                          //details
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Detail address'),
                            focusNode: _addressFocusNode,
                            maxLines: 3,
                            controller: _addressController,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide full address !';
                              } else if (value.length < 11) {
                                return 'Should be at least 10 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 40),
                          // Just a text before the pointsBar
                          Text(
                            'Your Bonus Points ( $fp )',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                decoration: TextDecoration.underline),
                          ),
                          SizedBox(height: 4),
                          PointDemoRow(),
                          // pointBar
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: pointBar(fp),
                          ),
                          // Use Points TextField
                          Container(
                            height: 40,
                            //width: 80,
                            //padding: EdgeInsets.all(20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Use Points:'),
                                  SizedBox(width: 25),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'press  Y or N',
                                      ),
                                      onSaved: (value) {
                                        if (value == "y" || value == "Y") {
                                          setState(() {
                                            _isUsePointsYes = true;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ]),
                          ),
                          SizedBox(height: 7),
                          //voucher code
                          Container(
                            height: 70,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Use Voucher:'),
                                  SizedBox(width: 10),
                                  // Voucher textField
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Voucher code'),
                                      focusNode: _voucherFocusNode,
                                      textInputAction: TextInputAction.done,
                                      controller: _voucherController,
                                      validator: (value) {
                                        if (value.trim().isNotEmpty &&
                                            _isVoucherCodeOk) {
                                          return null;
                                        } else if (value.trim().isEmpty &&
                                            !_isVoucherCodeOk) {
                                          return null;
                                        }
                                        return 'please Verify code first';
                                      },
                                    ),
                                  ),
                                  //check Button
                                  ElevatedButton(
                                    onPressed: () async {
                                      final String _voucherText =
                                          _voucherController.text.trim();
                                      if (_voucherText.isNotEmpty) {
                                        checkingVoucher(_voucherText);
                                        Future.delayed(
                                            Duration(microseconds: 150));
                                      }
                                    },
                                    child: Text('Verify'),
                                  ),
                                  // success icon
                                  Container(
                                      width: 45,
                                      child: _isVoucherCodeOk
                                          ? Icon(Icons.check_box,
                                              color: Colors.green, size: 50)
                                          : Icon(Icons.cancel,
                                              color: Colors.red, size: 30)),
                                ]),
                          ),
                          SizedBox(height: 20),
                          // Commit Button
                          Container(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isInit = !_isInit;
                                });
                              },
                              icon: Icon(Icons.shopping_bag),
                              label: Text('Comit to purchase'),
                            ),
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
                                          ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
    );
  }
}

class YellowDesign extends StatelessWidget {
  YellowDesign(this.size);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .32,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xFFFDD148),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(180.0),
        ),
      ),
      child: Stack(children: [
        Positioned(
          right: size.width * .4,
          child: Container(
            height: 400.0,
            width: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: Color(0xFFFEE16D),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          left: size.width * .4,
          child: Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Color(0xFFFEE16D).withOpacity(0.5))),
        ),
        Positioned(
          bottom: size.height * .13,
          left: size.width * .1,
          child: Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Color(0xFFFDD148).withOpacity(0.7))),
        ),
      ]),
    );
  }
}

class PointDemoRow extends StatelessWidget {
  const PointDemoRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('  0',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text('40', style: TextStyle(fontSize: 11)),
        Text('80', style: TextStyle(fontSize: 11)),
        Text('120', style: TextStyle(fontSize: 11)),
        Text('160', style: TextStyle(fontSize: 11)),
        Text('200',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
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
      height: 430,
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Card(
        color: Colors.blue[50],
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: ' Terms & Conditions\n\n\n',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text:
                  '   Delivery of the product will be completed within approximately 7 working days.\n\n',
              style: TextStyle(color: Colors.black)),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text: '   Delivered products can be returned within 7 days.\n\n',
              style: TextStyle(color: Colors.black)),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text:
                  '   You can return or compain by filling up the form from your profile page.\n\n',
              style: TextStyle(color: Colors.black)),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text: '    Vat won\'t be included.\n\n',
              style: TextStyle(color: Colors.black)),
          WidgetSpan(
              child:
                  Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
          TextSpan(
              text: '   Delivery charge ${35}.tk will be included.\n\n\n',
              style: TextStyle(color: Colors.black)),
          TextSpan(
              text: '  Shipping Method  :   ',
              style: TextStyle(color: Colors.black)),
          WidgetSpan(
              child: Icon(Icons.car_rental, size: 24, color: Colors.black)),
          TextSpan(
              text: '\n\n  Payment Method  :   ',
              style: TextStyle(color: Colors.black)),
          WidgetSpan(child: Icon(Icons.money, size: 24, color: Colors.black)),
          TextSpan(
              text: '  ( cash in Delivery )\n\n\n',
              style: TextStyle(color: Colors.black)),
          TextSpan(
              text: ' I agree to the Terms & Conditions...\n\n',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
        ])),
      ),
    );
  }
}
