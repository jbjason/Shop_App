import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List<String> comments = [];

  final _titleController = TextEditingController();

  void submitData() {
    final enteredTitle = _titleController.text;
    setState(() {
      comments.add(enteredTitle);
    });
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            //height: 300,
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              // comment section Row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Comments section',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  Icon(Icons.comment),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(children: [
            Container(
              color: Colors.white,
              width: 240,
              child: TextField(
                decoration: InputDecoration(labelText: '   Title'),
                controller: _titleController,
              ),
            ),
            Container(
              width: 80,
              color: Colors.black26,
              child: FlatButton(
                onPressed: submitData,
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
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Text(' # ${index + 1}'),
                ),
                title: Text(comments[index]),
              ),
              itemCount: comments.length,
            )),
          ),
        ],
      ),
    );
  }
}
