import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuggestionReportScreen extends StatefulWidget {
  static const routeName = '/suggestion-report-screen';
  @override
  _SuggestionReportScreenState createState() => _SuggestionReportScreenState();
}

class _SuggestionReportScreenState extends State<SuggestionReportScreen> {
  final _subjectFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String email, subject, description;

  @override
  void dispose() {
    _subjectFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<Orders>(context, listen: false)
        .addSuggestionReport(email, subject, description);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context).settings.arguments as String;

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
              TextFormField(
                initialValue: userEmail,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_subjectFocusNode);
                },
                validator: (value) {
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Subject'),
                textInputAction: TextInputAction.next,
                focusNode: _subjectFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  // return null means valid number
                  return null;
                },
                onSaved: (value) => subject = value,
              ),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Whole in Details'),
                  textInputAction: TextInputAction.newline,
                  focusNode: _descriptionFocusNode,
                  maxLines: 7,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    // return null means valid number
                    return null;
                  },
                  onSaved: (value) => description = value),
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
                  onPressed: () => _saveForm(),
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
