import 'package:Shop_App/providers/auth.dart';
import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  final String id;
  Comments(this.id);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List<String> comments = [];

  final _titleController = TextEditingController();

  void submitData(String _email) {
    final enteredTitle = _titleController.text;
    final String _comment = _email + ' -: ' + enteredTitle;
    Provider.of<Products>(context, listen: false)
        .addComments(widget.id, _comment);
    setState(() {
      comments.add(enteredTitle);
    });
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String email = Provider.of<Auth>(context, listen: false).userEmail;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 15),
          Row(children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: '   Title'),
                controller: _titleController,
              ),
            ),
            Container(
              width: 80,
              color: Colors.black54,
              child: FlatButton(
                onPressed: () => submitData(email),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 150,
            width: double.infinity,
            color: Colors.amber,
            child: Card(
                child: ListView.builder(
              itemBuilder: (context, index) => RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${index + 1}.  $email',
                    style: TextStyle(
                      backgroundColor: Colors.black54,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' -:  ${comments[index]}\n',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ]),
              ),
              itemCount: comments.length,
            )),
          ),
        ],
      ),
    );
  }
}
