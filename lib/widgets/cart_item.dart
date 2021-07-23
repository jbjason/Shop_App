import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id, title, productId, imageUrl, size, color;
  final int quantity;
  final double price;
  final Function updateFunction;

  CartItem(this.id, this.productId, this.title, this.price, this.quantity,
      this.imageUrl, this.updateFunction, this.color, this.size);
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Alert !'),
            content: Text('Do you want to remove the item?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.productId);
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 7.0,
          child: Container(
            padding: EdgeInsets.only(left: 15.0, right: 10.0),
            width: MediaQuery.of(context).size.width - 20.0,
            height: 150.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Row(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 25.0,
                      width: 25.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: Center(
                          child: Container(
                        height: 12.0,
                        width: 12.0,
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(6.0)),
                      )))
                ],
              ),
              SizedBox(width: 10.0),
              Container(
                height: 150.0,
                width: 125.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.contain),
                ),
              ),
              SizedBox(width: 4.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.title}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    'Color:  ${widget.color}',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.grey),
                  ),
                  Text(
                    'Size: ${widget.size}',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10.0),
                  Row(children: [
                    Text(
                      '\$${widget.price}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Color(0xFFFDD34A)),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 80,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: OutlineButton(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.remove, size: 12),
                              onPressed: () {
                                if (count <= 1) {
                                } else {
                                  setState(() {
                                    count--;
                                    widget.updateFunction(
                                        widget.productId, count);
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(count.toString().padLeft(2, '0')),
                          SizedBox(width: 3),
                          SizedBox(
                            height: 25,
                            width: 27,
                            child: OutlineButton(
                              color: Colors.lightBlue,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.add,
                                color: Colors.lightBlue,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  count++;
                                  widget.updateFunction(
                                      widget.productId, count);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              )
            ]),
          ),
        ),
      ),
      // child: Card(
      //   elevation: 3,
      //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      //   child: Padding(
      //     padding: EdgeInsets.all(8),
      //     child: ListTile(
      //       leading: Padding(
      //         padding: EdgeInsets.all(5),
      //         child: FittedBox(
      //           child: FittedBox(
      //             fit: BoxFit.cover,
      //             child: CircleAvatar(
      //               backgroundImage: NetworkImage(
      //                 widget.imageUrl,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //       title: Text(widget.title),
      //       subtitle: Text(
      //           'Price: \$${(widget.price)}   ${widget.size} ${widget.color}'),
      //       trailing: Container(
      //         width: 80,
      //         child: Row(
      //           children: [
      //             SizedBox(
      //               height: 24,
      //               width: 24,
      //               child: OutlineButton(
      //                 padding: EdgeInsets.zero,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10)),
      //                 child: Icon(Icons.remove),
      //                 onPressed: () {
      //                   if (count <= 1) {
      //                   } else {
      //                     setState(() {
      //                       count--;
      //                       widget.updateFunction(widget.productId, count);
      //                     });
      //                   }
      //                 },
      //               ),
      //             ),
      //             SizedBox(width: 3),
      //             Text(count.toString().padLeft(2, '0')),
      //             SizedBox(width: 3),
      //             SizedBox(
      //               height: 23,
      //               width: 25,
      //               child: OutlineButton(
      //                 padding: EdgeInsets.zero,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10)),
      //                 child: Icon(Icons.add),
      //                 onPressed: () {
      //                   setState(() {
      //                     count++;
      //                     widget.updateFunction(widget.productId, count);
      //                   });
      //                 },
      //               ),
      //             ),
      //             //SizedBox(width: 10),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
