import 'package:flutter/material.dart';

class SuggestionReportScreen extends StatefulWidget {
  static const routeName = '/suggestion-report-screen';
  @override
  _SuggestionReportScreenState createState() => _SuggestionReportScreenState();
}

class _SuggestionReportScreenState extends State<SuggestionReportScreen> {
  final _subjectFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isInit = false;
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
    print(email);
    print(subject);
    print(description);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context).settings.arguments as String;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            TextFormField(
              initialValue: userEmail[0],
              readOnly: true,
              decoration: InputDecoration(labelText: 'Email'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_subjectFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value';
                }
                // return null means valid number
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
                maxLines: 5,
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
                  elevation: 3,
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
    );
  }
}
