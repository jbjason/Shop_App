import '../screens/order_details_screen.dart';
import '../screens/view_offer_screen.dart';
import 'package:flutter/services.dart';
import '../models/offer.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffersScreen extends StatelessWidget {
  static const routeName = '/offers-screen';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFDD148),
      statusBarBrightness: Brightness.light,
    ));
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              return Container(height: 300, child: Text('An error occured'));
            } else {
              final _imageslist = Provider.of<Products>(context).offersImages;
              return Stack(children: [
                YellowDesign(size),
                Column(children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 6),
                  IconButton(
                    alignment: Alignment.topLeft,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  //Available Offers
                  Text(
                    'Available Offers',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) =>
                            OffersImagesItem(_imageslist[index]),
                        itemCount: _imageslist.length,
                      ),
                    ),
                  ),
                ]),
              ]);
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
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ViewOfferScreen.routeName, arguments: 'offer');
        },
        child: Stack(children: [
          Image.network(
            widget.product.imageUrl,
            fit: BoxFit.fill,
            height: 300,
            width: double.infinity,
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: _isLoading
                ? CircularProgressIndicator(backgroundColor: Colors.pink)
                : IconButton(
                    icon: Icon(Icons.delete_sharp),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<Products>(context, listen: false)
                          .deleteOffers(widget.product)
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                  title: Text('Alert !'),
                                  content: Text('Successfully Deleted..!')));
                        });
                      });
                    }),
          )
        ]),
      ),
    );
  }
}
