import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetSpecialOfferScreen extends StatefulWidget {
  static const routeName = '/set-special-offer';
  @override
  _SetSpecialOfferScreenState createState() => _SetSpecialOfferScreenState();
}

class _SetSpecialOfferScreenState extends State<SetSpecialOfferScreen> {
  final _currentPriceFocusNode = FocusNode();
  final _offerPriceFocusNode = FocusNode();
  var _expanded = false;
  String oldPrice, offerPrice;

  void _save() {
    print(oldPrice);
    print(offerPrice);
  }

  @override
  void dispose() {
    _currentPriceFocusNode.dispose();
    _offerPriceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return SafeArea(
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
                  subtitle: Text('  dfdjdf '),
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
                  //color: Colors.blueGrey[200],
                  child: CondtionsForReturns(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
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
                      initialValue: product.price.toString(),
                      focusNode: _currentPriceFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(),
                      onFieldSubmitted: (value) {
                        oldPrice = value;
                        FocusScope.of(context)
                            .requestFocus(_offerPriceFocusNode);
                      },
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
                    initialValue: product.extra,
                    focusNode: _offerPriceFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) => offerPrice = value,
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
            text: '   2.  Leave the offer text either blank or type \'No\'\n',
            style: TextStyle(
              color: Colors.black,
            )),
      ]),
    );
  }
}
