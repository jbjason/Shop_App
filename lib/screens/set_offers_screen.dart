import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetOffersScreen extends StatefulWidget {
  static const routeName = '/set-offers-screen';
  @override
  _SetOffersScreenState createState() => _SetOffersScreenState();
}

class _SetOffersScreenState extends State<SetOffersScreen> {
  final _form = GlobalKey<FormState>();
  final _imageFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _voucherFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _amountController = TextEditingController();
  final _voucherController = TextEditingController();

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    String _imageUrl = _imageController.text;
    String _amount = _amountController.text;
    String _voucherCode = _voucherController.text;
    Provider.of<Products>(context, listen: false)
        .setOffers(_imageUrl, _amount, _voucherCode);
    Navigator.of(context).pop();
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
  void dispose() {
    _amountFocusNode.dispose();
    _voucherFocusNode.dispose();
    _amountController.dispose();
    _voucherController.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Customer Orders',
            style: TextStyle(fontSize: 20, color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(13),
        child: Padding(
          padding: EdgeInsets.all(13),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green),
                  ),
                  child: _imageController.text.isEmpty
                      ? Center(child: Text('Enter a URL'))
                      : FittedBox(
                          child: Image.network(
                            _imageController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image Url'),
                  keyboardType: TextInputType.url,
                  controller: _imageController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
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
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Target Amount'),
                  textInputAction: TextInputAction.next,
                  focusNode: _amountFocusNode,
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_voucherFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide the amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Voucher Code'),
                  focusNode: _voucherFocusNode,
                  textInputAction: TextInputAction.done,
                  controller: _voucherController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide the code';
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
