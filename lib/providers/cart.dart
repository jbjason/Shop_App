import 'package:flutter/cupertino.dart';

class CartItem {
  final String id, title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var a = 0.0;
    _items.forEach((key, value) {
      a += value.price * value.quantity;
    });
    return a;
  }

  void addItem(
      String productId, double price, String title, String keyId, int quan) {
    if (_items.containsKey(productId) && keyId == 2.toString()) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          //imageUrl: existingItem.imageUrl,
          price: existingItem.price,
          quantity: quan,
        ),
      );
    } else if (_items.containsKey(productId) && keyId == 1.toString()) {
      return;
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          //imageUrl: imageUrl,
          price: price,
          quantity: quan,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    // remove kore selected item of (_items list)
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String proId) {
    if (!_items.containsKey(proId)) return;
    if (_items[proId].quantity > 1) {
      _items.update(
          proId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    } else {
      _items.remove(proId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
