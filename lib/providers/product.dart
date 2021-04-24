import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id, title, description;
  final String imageUrl1, imageUrl2, imageUrl3;
  final double price;
  bool isFavorite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    bool oldF = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-update-67f54.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      await http.put(url,
          body: json.encode(
            isFavorite,
          ));
    } catch (error) {
      isFavorite = oldF;
      notifyListeners();
    }
  }
}
