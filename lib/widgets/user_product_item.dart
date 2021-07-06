import '../screens/set_specialOffer_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title, imageUrl, id;
  final bool _offerPage;
  final int _available;
  UserProductItem(
      this.id, this.title, this.imageUrl, this._offerPage, this._available);

  void forShowDialoag(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Alert !'),
        content: Text('Do you want to remove the item ?'),
        actions: [
          FlatButton(
            onPressed: () async {
              await Provider.of<Products>(context, listen: false)
                  .deleteProduct(id);
            },
            color: Colors.green,
            child: Text('Yes'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.redAccent,
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      subtitle: Text('Available = $_available /-'),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
              onPressed: () {
                final route = _offerPage
                    ? SetSpecialOfferScreen.routeName
                    : EditProductScreen.routeName;
                Navigator.of(context).pushNamed(route, arguments: id);
              },
            ),
            _offerPage
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () async {
                      try {
                        forShowDialoag(context);
                      } catch (error) {
                        scaffold.showSnackBar(SnackBar(
                          content: Text('Deleteing Failed'),
                        ));
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
