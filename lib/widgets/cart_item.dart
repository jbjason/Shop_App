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
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.imageUrl,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(widget.title),
            subtitle: Text(
                'Price: \$${(widget.price)}   ${widget.size} ${widget.color}'),
            trailing: Container(
              width: 80,
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: OutlineButton(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.remove),
                      onPressed: () {
                        if (count <= 1) {
                        } else {
                          setState(() {
                            count--;
                            widget.updateFunction(widget.productId, count);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(count.toString().padLeft(2, '0')),
                  SizedBox(width: 3),
                  SizedBox(
                    height: 23,
                    width: 25,
                    child: OutlineButton(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          count++;
                          widget.updateFunction(widget.productId, count);
                        });
                      },
                    ),
                  ),
                  //SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
