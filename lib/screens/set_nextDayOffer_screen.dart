import 'package:Shop_App/providers/products.dart';
import 'package:Shop_App/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetNextDayOfferScreen extends StatefulWidget {
  static const routeName = '/next-day-offer';
  @override
  _SetNextDayOfferScreenState createState() => _SetNextDayOfferScreenState();
}

class _SetNextDayOfferScreenState extends State<SetNextDayOfferScreen> {
  final _imageFocusNode = FocusNode();
  final _dayFocusNode = FocusNode();
  final _hourFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _dayController = TextEditingController();
  final _hourController = TextEditingController();
  bool _hints = false;
  final _form = GlobalKey<FormState>();

  void _saveForm(String name) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    final _day = int.parse(_dayController.text.trim());
    final _hour = int.parse(_hourController.text.trim());
    final DateTime _cuurent = DateTime.now();
    final DateTime _deadLine =
        _cuurent.add(Duration(days: _day, hours: _hour, minutes: 0));
    await Provider.of<Products>(context, listen: false)
        .setOffersNextDayDelivery(
            _imageController.text.trim(), name, _deadLine);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Offer has been Saved')));
    setState(() {
      _hints = true;
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _dayController.dispose();
    _hourController.dispose();
    _imageFocusNode.dispose();
    _dayFocusNode.dispose();
    _hourFocusNode.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments as String;
    bool _specialOffer =
        name == "specialOffer" || name == "combo" ? true : false;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Manage Offer'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(name),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            reverse: true,
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.green),
                ),
                child: _imageController.text.isEmpty
                    ? Center(child: Text('Enter a URL'))
                    : FittedBox(
                        child: Image.network(
                          _imageController.text,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      focusNode: _imageFocusNode,
                      controller: _imageController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.url,
                      onFieldSubmitted: (_) {
                        setState(() {});
                        FocusScope.of(context).requestFocus(_dayFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Url';
                        } else if ((!value.startsWith('http') &&
                                !value.startsWith('https')) ||
                            (!value.endsWith('.jpg') &&
                                !value.endsWith('.png'))) {
                          return 'Please enter a valid Url';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              ),
              Row(
                children: [
                  Text(
                    'DURATION :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Days'),
                    textInputAction: TextInputAction.next,
                    focusNode: _dayFocusNode,
                    keyboardType: TextInputType.number,
                    controller: _dayController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_hourFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Can\'t be Blank';
                      }
                      // return null means valid number
                      return null;
                    },
                  )),
                  SizedBox(width: 20),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Hours'),
                    textInputAction: TextInputAction.done,
                    focusNode: _hourFocusNode,
                    controller: _hourController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Can\'t be Blank';
                      }
                      // return null means valid number
                      return null;
                    },
                  )),
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                height: _specialOffer && _hints ? 150 : 0,
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      Text(
                        ' To Edit Products prices Go to manage Special/Combo offer.\n Or Press this button below...',
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                UserProductsScreen.routeName,
                                arguments: 'offer');
                          },
                          child: Text("Manage price"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ].reversed.toList(),
          ),
        ),
      ),
    );
  }
}
