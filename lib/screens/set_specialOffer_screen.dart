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
  final _descriptionController = TextEditingController();
  var _expanded = false, _isInit = false, productId;

  void _save() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    final String oldPrice = _currentPriceController.text.trim();
    final String offerPrice = _offerPriceController.text.trim();
    final String description = _descriptionController.text.trim();
    await Provider.of<Products>(context, listen: false)
        .updateOfferProduct(productId, oldPrice, offerPrice, description);
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
    _descriptionController.text = product.description;
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentPriceController.dispose();
    _offerPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
          child: Form(
            key: _form,
            child: Column(
              children: [
                Card(
                  elevation: 7,
                  //margin: EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      'Instructions of Set/Removing offer',
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
                SizedBox(height: 30),
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
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    )),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: _descriptionController,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
            text:
                '   1.  Set new Specialoffer price or leave it as \'No\'.\n\n',
            style: TextStyle(
              color: Colors.black,
            )),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
            text: '   2.  For setting Combo offer type \'combo\' \n',
            style: TextStyle(
              color: Colors.black,
            )),
      ]),
    );
  }
}
