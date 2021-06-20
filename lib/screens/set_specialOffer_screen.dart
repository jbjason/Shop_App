import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetSpecialOfferScreen extends StatefulWidget {
  static const routeName = '/set-special-offer';
  @override
  _SetSpecialOfferScreenState createState() => _SetSpecialOfferScreenState();
}

class _SetSpecialOfferScreenState extends State<SetSpecialOfferScreen> {
  final _currentPriceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  var _expanded = false, _isInit = false, productId;

  void _save() async {
    final String oldPrice = _currentPriceController.text.trim();
    final String offerPrice = _offerPriceController.text.trim();
    await Provider.of<Products>(context, listen: false)
        .updateOfferProduct(productId, oldPrice, offerPrice);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Updated Successfully')));
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) return;
    productId = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    _currentPriceController.text = product.price.toString();
    _offerPriceController.text = product.extra;
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentPriceController.dispose();
    _offerPriceController.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFC8E6C9),
          title: Text(
            'Manage Discount Price',
            style: TextStyle(fontSize: 20, color: Colors.black87),
          ),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _save)],
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Card(
                elevation: 7,
                //margin: EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    'Instructions of removing offer',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(' ( This might help you ) '),
                  trailing: IconButton(
                      icon: Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.cyan,
                        size: 35,
                      ),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      }),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: _expanded == false ? 0 : 90,
                width: double.infinity,
                child: Card(
                  child: CondtionsForReturns(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                      child: Text(
                    "Current Price    :",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(
                    child: TextFormField(
                      controller: _currentPriceController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 15),
                  Expanded(
                      child: Text(
                    "Offer Price    :",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(
                      child: TextFormField(
                    controller: _offerPriceController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value';
                      }
                      return null;
                    },
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CondtionsForReturns extends StatelessWidget {
  const CondtionsForReturns({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '\n',
        ),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
            text: '   1.  Remove the offer price.\n\n',
            style: TextStyle(
              color: Colors.black,
            )),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
            text: '   2.  Leave the offer text with typing \'No\'\n',
            style: TextStyle(
              color: Colors.black,
            )),
      ]),
    );
  }
}
