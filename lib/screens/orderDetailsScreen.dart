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

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _emailFocusNode.dispose();
    _detailsFocusNode.dispose();
    super.dispose();
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
                ),
                // email
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email-address'),
                  focusNode: _emailFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_numberFocusNode);
                  },
                ),
                //phn
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact number'),
                  focusNode: _numberFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_detailsFocusNode);
                  },
                ),
                //details
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address details'),
                  focusNode: _detailsFocusNode,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                //phn

                FlatButton(
                  onPressed: () {},
                  child: Text('Submit'),
                  textColor: Colors.green,
                ),
              ],
            )),
      ),
    );
  }
}
