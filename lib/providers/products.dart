import 'package:Shop_App/models/http_exception.dart';
import 'package:Shop_App/models/offer.dart';
import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  String authToken, userId;
  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  List<String> _commentsList = [];
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/51c%2BT7XynwL._AC_UX679_.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trowser',
    //   description: 'this is a pan for helping home chores',
    //   price: 20.45,
    //   imageUrl:
    //       'https://i.pinimg.com/474x/e4/ed/45/e4ed45ddf937abb7c3862469a15372c8.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'this is a pan for helping home chores',
    //   price: 20.45,
    //   imageUrl:
    //       'https://www.grandrivershotokan.ca/wp-content/uploads/2018/12/1029.40.png',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'this is a pan for helping home chores',
    //   price: 20.45,
    //   imageUrl:
    //       'https://static01.nyt.com/images/2011/01/26/business/pan2/pan2-blog480.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<String> get commentsList {
    return [..._commentsList];
  }

  List<String> _searcHints = [];
  List<String> get searcHints {
    return [..._searcHints];
  }

  List<Offer> _offersList = [];
  List<Offer> get offerList {
    return [..._offersList];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // imageUrl2 & imageUrl3 empty return korbe jodi url insert kora na thake
  Future<void> fetchAndSetProducts() async {
    //String filterString =filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-update-67f54.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) return;
      url =
          'https://flutter-update-67f54.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((proId, prodData) {
        loadedProducts.add(Product(
          id: proId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl1: prodData['imageUrl1'],
          imageUrl2: prodData['imageUrl2'],
          imageUrl3: prodData['imageUrl3'],
          // if favoriteData or no_entry_for_this_user then return false(unchecked)
          isFavorite:
              favoriteData == null ? false : favoriteData[proId] ?? false,
          isRating: prodData['isRating'],
          isReview: prodData['isReview'],
          category: prodData['category'],
        ));
        _searcHints.add(prodData['title']);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl1': product.imageUrl1,
          'imageUrl2': product.imageUrl2,
          'imageUrl3': product.imageUrl3,
          'creatorId': userId,
          'isRating': product.isRating,
          'isReview': product.isReview,
          'category': product.category,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl1: product.imageUrl1,
        imageUrl2: product.imageUrl2,
        imageUrl3: product.imageUrl3,
        // this give access code of (.post's) body as Map like
        // {name: -MMU-mCP6SqbQBL5yZFB} so to use this as Unique id we can....
        id: json.decode(response.body)['name'],
        isRating: product.isRating,
        isReview: product.isReview,
        category: product.category,
      );
      // adding
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken';
    final exIndex = _items.indexWhere((element) => element.id == id);
    var exProduct = _items[exIndex];
    _items.removeAt(exIndex);
    notifyListeners();
    final response = await http.delete(url);
    // 400 er upore means Error occurs
    if (response.statusCode >= 400) {
      _items.insert(exIndex, exProduct);
      notifyListeners();
      // its additional
      throw HttpException('Could not delete product');
    }
    exProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          //'imageUrl': newProduct.imageUrl,
        }));
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> updateRatingAndReview(String id, double newRating) async {
    final int index = _items.indexWhere((element) => element.id == id);
    final double oldRating = _items[index].isRating;
    newRating = (oldRating + newRating) / 2.0;
    final int newReview = _items[index].isReview + 1.toInt();
    final url =
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken';
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isRating': newRating,
          'isReview': newReview,
        }),
      );
      if (response.statusCode >= 400) {
        _items[index].isRating = oldRating;
      }
    } catch (error) {
      _items[index].isRating = oldRating;
    }
    notifyListeners();
  }

  Future<void> addComments(String id, String s) async {
    try {
      var url = Uri.parse(
          'https://flutter-update-67f54.firebaseio.com/comments/$id.json?auth=$authToken');
      await http.post(url,
          body: json.encode({
            'comment': s,
          }));
      _commentsList.add(s);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetComments(String id) async {
    try {
      var url = Uri.parse(
          'https://flutter-update-67f54.firebaseio.com/comments/$id.json?auth=$authToken');
      final response = await http.get(url);
      final extractedComments =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedComments == null) {
        _commentsList = [];
        return;
      }
      final List<String> loadedComments = [];
      extractedComments.forEach((productId, productValue) {
        loadedComments.add(productValue['comment']);
      });
      _commentsList = loadedComments;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void serachForProduct(String s) {
    _items = _items.where((element) => element.title.contains(s)).toList();
    notifyListeners();
  }

  Future<void> setOffersUptoAmount(
      String imageUrl, String amount, String voucherCode) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/offers/uptoAmount.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'imageUrl': imageUrl,
            'amount': amount,
            'voucherCode': voucherCode,
          }));
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOffersUpto() async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/offers/uptoAmount.json?auth=$authToken';
    final response = await http.get(url);
    final extractedOffers = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOffers == null) return;
    final List<Offer> loadedList = [];
    extractedOffers.forEach((id, value) {
      final String s = value['amount'];
      loadedList.add(Offer(
          id: id,
          imageUrl: value['imageUrl'],
          voucherCode: value['voucherCode'],
          amount: double.parse(s)));
    });
    _offersList = loadedList;
    notifyListeners();
  }
}
