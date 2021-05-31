import 'package:Shop_App/widgets/chart.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String email, userId;
  UserProfile(this.email, this.userId);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 150,
            width: 150,
            margin: EdgeInsets.only(top: 20, bottom: 15),
            child: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/pinch2.png',
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: size.width,
            child: Row(
              children: [
                Container(
                  width: size.width * .35,
                  // color: Colors.amber,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'LocalId  :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(width: size.width * .05),
                Expanded(
                  child: TextFormField(
                    initialValue: "  " + userId,
                    onTap: () => null,
                  ),
                ),
                SizedBox(width: size.width * .1),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  // color: Colors.blue,
                  width: size.width * .35,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'User_Email :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: size.width * .05),
                Expanded(
                  child: TextFormField(
                    initialValue: "  " + email,
                  ),
                ),
                SizedBox(width: size.width * .1),
              ],
            ),
          ),
          Container(
            //height: 300,
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.all(20),
              // comment section Row
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'History ',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.history_rounded,
                        size: 30,
                      ),
                    ],
                  ),
                  Text('(  last seven days  )'),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .27,
            child: Chart(),
          ),
        ],
      ),
    );
  }
}
