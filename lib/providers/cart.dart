import 'package:flutter/cupertino.dart';

class CartItem {
  final String id, title, imageUrl, color, size;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
    @required this.color,
    @required this.size,
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

  void addItem(String productId, double price, String imageUrl, String title,
      int quan, String selectedColor, String selectedSize) {
    _items.putIfAbsent(
      productId,
      () => CartItem(
        id: productId,
        title: title,
        imageUrl: imageUrl,
        price: price,
        quantity: quan,
        color: selectedColor,
        size: selectedSize,
      ),
    );
    notifyListeners();
  }

  void update(String productId, int quan) {
    _items.update(
      productId,
      (existingItem) => CartItem(
        id: existingItem.id,
        title: existingItem.title,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: quan,
        color: existingItem.color,
        size: existingItem.size,
      ),
    );
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
                imageUrl: value.imageUrl,
                quantity: value.quantity - 1,
                price: value.price,
                color: value.color,
                size: value.size,
              ));
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
