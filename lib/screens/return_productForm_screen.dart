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
  final _orderIdFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _expanded = false;
  String _productId, _description, _contact, _address, _orderId;

  @override
  void dispose() {
    _productIdFocusNode.dispose();
    _orderIdFocusNode.dispose();
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
        email, _orderId, _productId, _contact, _address, _description);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Return Form',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              //Condition & terms of return
              ListTile(
                title: Text(
                  '     Conditions of Return',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('( Check you match these conditions )'),
                trailing: IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    }),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: _expanded == false ? 5 : 370,
                width: double.infinity,
                child: Card(
                  color: Colors.blueGrey[900],
                  child: CondtionsForReturns(),
                ),
              ),
              // email
              TextFormField(
                initialValue: userEmail,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_orderIdFocusNode);
                },
                validator: (value) {
                  return null;
                },
              ),
              // Order-Id
              TextFormField(
                decoration: InputDecoration(labelText: 'Order Id'),
                textInputAction: TextInputAction.next,
                focusNode: _orderIdFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_productIdFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide the subject';
                  }
                  return null;
                },
                onSaved: (value) => _orderId = value,
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
                  FocusScope.of(context).requestFocus(_addressFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide contact number';
                  }
                  return null;
                },
                onSaved: (value) => _contact = value,
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

class CondtionsForReturns extends StatelessWidget {
  const CondtionsForReturns({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: 'Conditions :\n\n\n',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
          text:
              '   1.  The product must be unused, unworn, unwashed and without any flaws. Fashion products can be tried on to see if they fit and will still be considered unworn. \n\n',
        ),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
          text:
              '   2.  The product must include the original tags, user manual, warranty cards, freebies and accessories.\n\n',
        ),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
          text:
              '   3. The product must be returned in the original and undamaged manufacturer packaging / box.\n\n',
        ),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
          text:
              '    4. If a product is returned to us in an inadequate condition, we reserve the right to send it back to you.\n\n',
        ),
        WidgetSpan(
            child: Icon(Icons.donut_small, size: 16, color: Colors.deepOrange)),
        TextSpan(
          text:
              '   5. If you are located in Dhaka city, then you will be able to avail pick up and drop off both facilities from specific areas. If you are located outside Dhaka, we have customer return drop off points in different locations where you can drop your return product.\n\n\n',
        ),
      ]),
    );
  }
}
