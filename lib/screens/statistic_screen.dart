import '../providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatelessWidget {
  static const routeName = '/statistic-screen';

  @override
  Widget build(BuildContext context) {
    final statData = Provider.of<Orders>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Customer Orders',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetStatistic(),
          builder: (context, dataSnapShot) {
            if (ConnectionState.waiting == dataSnapShot.connectionState) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.pink,
              ));
            } else if (dataSnapShot.error != null) {
              return Center(child: Text('An error occured'));
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                          margin: EdgeInsets.all(15),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                width: size.width * .3,
                                child: Text(
                                  'Total Revenue:  ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                '${statData.totalRevenue} /=',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            ],
                          )),
                      Divider(
                        color: Colors.pink,
                        height: 5,
                        thickness: 3,
                      ),
                      Container(
                          margin: EdgeInsets.all(15),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                width: size.width * .3,
                                child: Text(
                                  'Total Sell:  ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                '${statData.totalSell} -',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            ],
                          )),
                      Divider(
                        color: Colors.pink,
                        height: 5,
                        thickness: 3,
                      ),
                      Container(
                          margin: EdgeInsets.all(15),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                width: size.width * .3,
                                child: Text(
                                  'Total Pending:  ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                '${statData.totalPending} -',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            ],
                          )),
                      Divider(
                        color: Colors.pink,
                        height: 5,
                        thickness: 3,
                      ),
                      Container(
                          margin: EdgeInsets.all(15),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                width: size.width * .3,
                                child: Text(
                                  'Returns Pending:  ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                '${statData.returnProducts.length} -',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )),
                            ],
                          )),
                      Divider(
                        color: Colors.pink,
                        height: 5,
                        thickness: 3,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
