import 'package:Shop_App/providers/products.dart';
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

  void _saveForm() {
    Provider.of<Products>(context, listen: false)
        .setOffersNextDayDelivery(_imageController.text.trim());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Manage Offers'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
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
            TextFormField(
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
                    (!value.endsWith('.jpg') && !value.endsWith('.png'))) {
                  return 'Please enter a valid Url';
                }
                return null;
              },
            ),
          ].reversed.toList(),
        ),
      ),
    );
  }
}
