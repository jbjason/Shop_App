import '../models/offer.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffersScreen extends StatelessWidget {
  static const routeName = '/offers-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC8E6C9),
        title: Text('Available Offers'),
      ),
      body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchOffersImagesList(),
          builder: (ctx, dataSnapShot) {
            if (ConnectionState.waiting == dataSnapShot.connectionState) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ));
            }
            if (dataSnapShot.error != null) {
              return Center(child: Text('An error occured'));
            } else {
              final _imageslist =
                  Provider.of<Products>(context, listen: false).offersImages;
              return ListView.builder(
                itemBuilder: (ctx, index) =>
                    OffersImagesItem(_imageslist[index]),
                itemCount: _imageslist.length,
              );
            }
          }),
    );
  }
}

class OffersImagesItem extends StatefulWidget {
  final OffersImagesList product;
  OffersImagesItem(this.product);
  @override
  _OffersImagesItemState createState() => _OffersImagesItemState();
}

class _OffersImagesItemState extends State<OffersImagesItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Image.network(
        widget.product.imageUrl,
        fit: BoxFit.fill,
        height: 300,
        width: double.infinity,
      ),
    );
  }
}
