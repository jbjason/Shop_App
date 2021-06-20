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
  final _imageController = TextEditingController();
  bool _hints = false;

  void _saveForm(String name) async {
    await Provider.of<Products>(context, listen: false)
        .setOffersNextDayDelivery(_imageController.text.trim(), name);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Offer has been Saved')));
    setState(() {
      _hints = true;
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments as String;
    bool _specialOffer = name == "specialOffer" ? true : false;
    return Scaffold(
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
                    keyboardType: TextInputType.url,
                    onFieldSubmitted: (_) {
                      setState(() {});
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
                              arguments: 'specialOffer');
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
    );
  }
}
