import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnProductScreen extends StatefulWidget {
  static const routeName = '/return-product';
  @override
  _ReturnProductScreenState createState() => _ReturnProductScreenState();
}

class _ReturnProductScreenState extends State<ReturnProductScreen> {
  final _productIdFocusNode = FocusNode();
  final _contactFocusNode = FocusNode();
  final _subjectFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isInit = false;
  String _productId, _description, _contact, _address, _subject;

  @override
  void dispose() {
    _productIdFocusNode.dispose();
    _subjectFocusNode.dispose();
    _contactFocusNode.dispose();
    _addressFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm(String email) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<Orders>(context, listen: false).addReturnForm(
        email, _productId, _contact, _subject, _address, _description);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context).settings.arguments as List<String>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Your Cart',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              // email
              TextFormField(
                initialValue: userEmail[0],
                readOnly: true,
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_productIdFocusNode);
                },
                validator: (value) {
                  return null;
                },
              ),
              // product-id
              TextFormField(
                decoration: InputDecoration(labelText: 'product-id'),
                textInputAction: TextInputAction.next,
                focusNode: _productIdFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_contactFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide the exact product-id';
                  }
                  return null;
                },
                onSaved: (value) => _productId = value,
              ),
              // contact no
              TextFormField(
                decoration: InputDecoration(labelText: 'contact number'),
                textInputAction: TextInputAction.next,
                focusNode: _contactFocusNode,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_subjectFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide contact number';
                  }
                  return null;
                },
                onSaved: (value) => _contact = value,
              ),
              // subject
              TextFormField(
                decoration: InputDecoration(labelText: 'subject'),
                textInputAction: TextInputAction.next,
                focusNode: _subjectFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_addressFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide the subject';
                  }
                  return null;
                },
                onSaved: (value) => _subject = value,
              ),
              // address
              TextFormField(
                decoration: InputDecoration(labelText: 'Address details'),
                textInputAction: TextInputAction.newline,
                focusNode: _addressFocusNode,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide current address in details';
                  }
                  return null;
                },
                onSaved: (value) => _address = value,
              ),
              // problem details
              TextFormField(
                  decoration: InputDecoration(labelText: 'Problem in Details'),
                  textInputAction: TextInputAction.newline,
                  focusNode: _descriptionFocusNode,
                  maxLines: 7,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value),
              SizedBox(height: 60),
              Container(
                height: 50,
                //alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.greenAccent,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                  onPressed: () => _saveForm(userEmail[0]),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
