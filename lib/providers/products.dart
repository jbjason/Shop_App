import 'package:Shop_App/providers/cart.dart';
import '../models/http_exception.dart';
import '../models/offer.dart';
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

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get specialOfferItems {
    // extra="no" means kono offer nai , extra=combo means combo offer
    // extra= ei 2ta naa hoye value thakle special offer Item oita
    return _items
        .where((element) => element.extra != "no" && element.extra != "combo")
        .toList();
  }

  List<Product> get comboOfferItems {
    return _items.where((element) => element.extra == "combo").toList();
  }

  List<String> _commentsList = [];
  List<String> get commentsList {
    return [..._commentsList];
  }

  List<String> _searcHints = [];
  List<String> get searcHints {
    return [..._searcHints];
  }

  List<Offer> _uptoOffersList = [];
  List<Offer> get uptoOffersList {
    return [..._uptoOffersList];
  }

  List<OffersImagesList> _offersImages = [];
  List<OffersImagesList> get offersImages {
    return [..._offersImages];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  int availableProduct(String id) {
    Product p = _items.firstWhere((element) => element.id == id);
    return p.available;
  }

  List<String> _categories = [];
  int _selectedCatIndex;
  List<String> get categories {
    return [..._categories];
  }

  void setSelectedCategoryIndex(int i) {
    _selectedCatIndex = i;
  }

  List<Product> get getSelectedCategoryList {
    if (_categories[_selectedCatIndex].toLowerCase() == "all") {
      return [..._items];
    } else
      return _items
          .where(
              (element) => _categories[_selectedCatIndex] == element.category)
          .toList();
  }

  List<Product> getRelatedProductsList(String name, String catgory, String id) {
    var s = _items
        .where((element) => element.title.contains(name) && element.id != id)
        .toList();
    if (s.length > 3) {
      return s;
    } else {
      return _items
          .where((element) =>
              element.title.contains(name) && element.id != id ||
              element.category == catgory)
          .toList();
    }
  }

  String search;
  void setSerachForProduct(String s) {
    search = s;
  }

  List<Product> get getSearchedList {
    return _items.where((element) => element.title.contains(search)).toList();
  }

  String cat = '';
  double pr = 0;
  void setSortProducts(String cat, double pr) {
    this.cat = cat;
    this.pr = pr;
  }

  List<Product> get getSortProducts {
    if (cat == "All") {
      return _items.where((element) => element.price <= pr).toList();
    }
    final v = _items
        .where(
            (element) => element.category.contains(cat) && element.price <= pr)
        .toList();
    if (v == null) {
      return [];
    } else
      return v;
  }

  int _deadLineDuration = 0;
  int get deadLineDuration {
    return _deadLineDuration;
  }

  Future<void> fetchAndSetCategories() async {
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/category.json?auth=$authToken');
    final response = await http.get(url);
    final extract = json.decode(response.body) as Map<String, dynamic>;
    final List<String> test = [];
    extract.forEach((_, value) {
      test.add(value);
    });
    _categories = test;
    notifyListeners();
  }

  // imageUrl2 & imageUrl3 empty return korbe jodi url insert kora na thake
  Future<void> fetchAndSetProducts() async {
    //String filterString =filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) return;
      url = Uri.parse(
          'https://flutter-update-67f54.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((proId, prodData) {
        loadedProducts.add(Product(
          id: proId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          available: prodData['available'],
          imageUrl1: prodData['imageUrl1'],
          imageUrl2: prodData['imageUrl2'],
          imageUrl3: prodData['imageUrl3'],
          // if favoriteData or no_entry_for_this_user then return false(unchecked)
          isFavorite:
              favoriteData == null ? false : favoriteData[proId] ?? false,
          isRating: prodData['isRating'],
          isReview: prodData['isReview'],
          category: prodData['category'],
          extra: prodData['extra'],
        ));
        _searcHints.add(prodData['title']);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(
      Product product, List<String> sizeList, List<String> colorList) async {
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'available': product.available,
          'imageUrl1': product.imageUrl1,
          'imageUrl2': product.imageUrl2,
          'imageUrl3': product.imageUrl3,
          'creatorId': userId,
          'isRating': product.isRating,
          'isReview': product.isReview,
          'category': product.category,
          'extra': product.extra,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        available: product.available,
        imageUrl1: product.imageUrl1,
        imageUrl2: product.imageUrl2,
        imageUrl3: product.imageUrl3,
        id: json.decode(response.body)['name'],
        isRating: product.isRating,
        isReview: product.isReview,
        category: product.category,
        extra: product.extra,
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
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken');
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
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken');
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
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken');
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

  Future<void> setOffersUptoAmount(String imageUrl, String amount,
      String voucherCode, String rewardPoint) async {
    var url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/offers/uptoAmount.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'rewardPoint': rewardPoint,
            'amount': amount,
            'voucherCode': voucherCode,
          }));
      if (_uptoOffersList.length < 1) {
        final String id = json.decode(response.body)['name'];
        url = Uri.parse(
            'https://flutter-update-67f54.firebaseio.com/offers/images/$id.json?auth=$authToken');
        await http.put(
          url,
          body: json.encode(
            imageUrl,
          ),
        );
      }
    } catch (error) {
      throw error;
    }
  }

  // nextDay & special offer image insert both in this method
  Future<void> setOffersNextDayDelivery(
      String imageUrl, String name, DateTime dateTime) async {
    var url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/offers/$name.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'imageUrl': imageUrl,
          'deadline': dateTime.toIso8601String(),
        }),
      );
      final String id = json.decode(response.body)['name'];
      url = Uri.parse(
          'https://flutter-update-67f54.firebaseio.com/offers/images/$id.json?auth=$authToken');
      await http.put(
        url,
        body: json.encode(
          imageUrl,
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOffersUptoAmount() async {
    var url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/offers/uptoAmount.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedOffers =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedOffers == null) return;
      final List<Offer> loadedList = [];
      extractedOffers.forEach((id, value) {
        final String s = value['amount'];
        final String ss = value['rewardPoint'];
        loadedList.add(
          Offer(
              id: id,
              rewardPoint: double.parse(ss),
              voucherCode: value['voucherCode'],
              amount: double.parse(s)),
        );
      });

      _uptoOffersList = loadedList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOffersImagesList() async {
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/offers/images.json?auth=$authToken');
    final response1 = await http.get(url);
    final extractedImages = json.decode(response1.body) as Map<String, dynamic>;
    if (extractedImages == null) return;
    extractedImages.forEach((id, value) {
      _offersImages.add(OffersImagesList(id: id, imageUrl: value));
    });
    notifyListeners();
  }

  Future<void> updateOfferProduct(
      String id, String oldPrice, String offerPrice, String description) async {
    // checking & set String as lowerCase
    try {
      double.parse(offerPrice);
    } catch (_) {
      offerPrice = offerPrice.toLowerCase();
    }
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/products/$id.json?auth=$authToken');
    try {
      await http.patch(url,
          body: json.encode({
            'price': oldPrice,
            'extra': offerPrice,
            'description': description,
          }));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetDeadLines() async {
    final url = Uri.parse(
        'https://flutter-update-67f54.firebaseio.com/offers/specialOffer.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extract = json.decode(response.body) as Map<String, dynamic>;
      extract.forEach((id, value) {
        DateTime date = DateTime.parse(value['deadline']);
        DateTime _current = DateTime.now();
        final difference = _current.difference(date).inMinutes;
        _deadLineDuration = -difference;
        if (_deadLineDuration < 0) {
          _deadLineDuration = 0;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateAvailableProduct(List<CartItem> finalProduct) async {
    int _availableCount, _updatedCount = 0;
    String _proId;

    finalProduct.forEach((element) async {
      _proId = element.id;
      _availableCount = availableProduct(_proId);
      // if availabe product is lesser than ordered then store 0
      if (element.quantity > _availableCount) {
        _updatedCount = 0;
      } else {
        _updatedCount = _availableCount - element.quantity;
      }
      final url = Uri.parse(
          'https://flutter-update-67f54.firebaseio.com/products/$_proId.json?auth=$authToken');
      try {
        await http.patch(url,
            body: json.encode({
              'available': _updatedCount,
            }));
      } catch (e) {
        print(e);
      }
      await Future.delayed(Duration(seconds: 2));
    });
  }
}
