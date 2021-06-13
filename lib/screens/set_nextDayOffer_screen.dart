import 'package:flutter/material.dart';

class SetNextDayOfferScreen extends StatefulWidget {
  static const routeName = '/next-day-offer';

  @override
  _SetNextDayOfferScreenState createState() => _SetNextDayOfferScreenState();
}

class _SetNextDayOfferScreenState extends State<SetNextDayOfferScreen> {
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _imageController.removeListener(_updateImageUrl);
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.png'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Manage Offers'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
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
              onFieldSubmitted: (_) {},
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
          ],
        ),
      ),
    );
  }
}
