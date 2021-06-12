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
  final _rewardPointFocusNode = FocusNode();
  final _rewardPointController = TextEditingController();
  final _imageController = TextEditingController();
  final _amountController = TextEditingController();
  final _voucherController = TextEditingController();

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    final String _imageUrl = _imageController.text;
    final String _amount = _amountController.text;
    final String _voucherCode = _voucherController.text;
    final String _rewardPoint = _rewardPointController.text;
    Provider.of<Products>(context, listen: false)
        .setOffersUptoAmount(_imageUrl, _amount, _voucherCode, _rewardPoint);
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
    _rewardPointFocusNode.dispose();
    _rewardPointController.dispose();
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
                SizedBox(height: 14),
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
                SizedBox(height: 14),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Target Amount'),
                  textInputAction: TextInputAction.next,
                  focusNode: _amountFocusNode,
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_rewardPointFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide the amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bonus Point'),
                  focusNode: _rewardPointFocusNode,
                  textInputAction: TextInputAction.next,
                  controller: _rewardPointController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_voucherFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide reward point';
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
