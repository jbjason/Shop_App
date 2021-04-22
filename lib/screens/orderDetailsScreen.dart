import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/orderDetailsScreen';
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _form = GlobalKey<FormState>();
  final _numberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _detailsFocusNode = FocusNode();
  Map<String, String> _info = {
    'name': '',
    'email': '',
    'contact': '',
    'details': '',
  };

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _emailFocusNode.dispose();
    _detailsFocusNode.dispose();
    super.dispose();
  }

  void submit() {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    print(_info['name']);
    print(_info['email']);
    print(_info['contact']);
    print(_info['details']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm ur details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                // name
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name !';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['name'] = value;
                  },
                ),
                // email
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email-address'),
                  focusNode: _emailFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_numberFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a email-address !';
                    } else if (!value.contains('@') ||
                        !value.contains('.com')) {
                      return 'Invalid email-adrress';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['email'] = value;
                  },
                ),
                //contact no
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact number'),
                  focusNode: _numberFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_detailsFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a contact number !';
                    } else if (value.length < 11) {
                      return 'Should be at least 11 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['contact'] = value;
                  },
                ),
                //details
                TextFormField(
                  decoration: InputDecoration(labelText: 'Details address'),
                  focusNode: _detailsFocusNode,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide full address !';
                    } else if (value.length < 11) {
                      return 'Should be at least 10 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _info['details'] = value;
                  },
                ),

                FlatButton(
                  onPressed: submit,
                  child: Text('Submit'),
                  textColor: Colors.green,
                ),
              ],
            )),
      ),
    );
  }
}
