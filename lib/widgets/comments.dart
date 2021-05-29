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
  final _titleController = TextEditingController();
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (!_isInit) return;
    Provider.of<Products>(context).fetchAndSetComments(widget.id);
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String email = Provider.of<Auth>(context, listen: false).userEmail;
    final product = Provider.of<Products>(context);
    List<String> comments = product.commentsList;
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
                onPressed: () {
                  final String _comment =
                      email + '_:  ' + _titleController.text;
                  product.addComments(widget.id, _comment);
                  setState(() {
                    comments.add(_comment);
                  });
                  _titleController.clear();
                },
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
                    text: '${index + 1}.  ',
                    style: TextStyle(
                      backgroundColor: Colors.red,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${comments[index]}\n',
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
