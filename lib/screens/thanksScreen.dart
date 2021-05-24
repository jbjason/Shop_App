import 'package:flutter/material.dart';

class ThanksScreen extends StatelessWidget {
  static const routeName = '/thanks-screen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 37),
              Text('Thank You !',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 3),
              Text(
                'Your order has been placed successfully',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              SizedBox(height: 12),
              Image.asset(
                'assets/images/success.png',
                fit: BoxFit.fill,
                height: 200,
              ),
              SizedBox(height: 20),
              Text('Estimated Delivary in 7days',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
              SizedBox(height: 25),
              Divider(
                color: Colors.green,
                thickness: 2,
              ),
              SizedBox(height: 25),
              Text('{7} items will delivery at'),
              Text('Mirpur Dhaka Eastern housing -1216'),
              SizedBox(height: 25),
              Divider(
                color: Colors.green,
                thickness: 2,
              ),
              SizedBox(height: 35),
              GestureDetector(
                onTap: () {
                  // for popping 2page at a time
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(color: Colors.green[100], boxShadow: [
                    BoxShadow(
                      offset: Offset(5, 3),
                      blurRadius: 10,
                      color: Colors.greenAccent,
                    ),
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/back_arrow_1.jpg',
                          fit: BoxFit.fill,
                          height: 32,
                        ),
                      ),
                      SizedBox(width: 14),
                      SizedBox(child: Text('|')),
                      SizedBox(width: 20),
                      Text(
                        ' Back to the Shop ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
