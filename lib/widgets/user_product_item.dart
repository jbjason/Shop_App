import '../screens/set_specialOffer_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title, imageUrl, id;
  final bool _offerPage;
  UserProductItem(this.id, this.title, this.imageUrl, this._offerPage);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
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
                ? Icon(null)
                : IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(id);
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
