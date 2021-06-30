import '../models/confirmOrdersClass.dart';
import '../models/http_exception.dart';
import '../models/returnClass.dart';
import './cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id, status;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    this.status = "Pending",
  });
}

class Orders with ChangeNotifier {
  final String authToken, userId;
  int _pointt;
  var timeStop, _customerOrderId;
  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  String get customerOrderId {
    return _customerOrderId.toString();
  }

  List<ConfirmOrdersClass> _customerOrders = [];
  List<ConfirmOrdersClass> get customerOrders {
    return [..._customerOrders];
  }

  List<ReturnClass> _returnProducts = [];
  List<ReturnClass> get returnProducts {
    return [..._returnProducts];
  }

  double _totalRevenue = 0;
  int _totalSell = 0;
  double get totalRevenue {
    return _totalRevenue;
  }

  int get totalSell {
    return _totalSell;
  }

  int get totalPending {
    final List<ConfirmOrdersClass> ss = _customerOrders
        .where(
          (element) => element.status == 'Pending',
        )
        .toList();
    return ss.length;
  }

  List<OrderItem> recentTransactions(int _day) {
    return _orders.where((element) {
      return element.dateTime
          .isAfter(DateTime.now().subtract(Duration(days: _day)));
    }).toList();
  }

  int get pointt {
    if (_pointt == null) {
      return _pointt = 2;
    }
    return _pointt;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    // empty list initialized
    final List<OrderItem> loadedOrders = [];
    // cz we know we have nested of nested Map's(nested has another map)
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        status: orderData['status'],
        // products come from Cart(which stored in CartItem)
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                imageUrl: item['imageUrl'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/orders/$userId.json?auth=$authToken';
    timeStop = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStop.toIso8601String(),
          'status': "Pending",
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _customerOrderId = json.decode(response.body)['name'];
    _orders.insert(
        0,
        OrderItem(
          id: _customerOrderId,
          amount: total,
          products: cartProducts,
          dateTime: timeStop,
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetCustomerOrders() async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/confirmedOrders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final List<ConfirmOrdersClass> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(ConfirmOrdersClass(
          id: orderId,
          orderId: orderData['orderId'],
          name: orderData['name'],
          email: orderData['email'],
          contact: orderData['contact'],
          address: orderData['address'],
          userLocalId: orderData['userId'],
          amount: orderData['amount'],
          status: orderData['status'],
          dateTime: DateTime.parse(orderData['dateTime']),
          cartProducts: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    imageUrl: item['imageUrl'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ));
      });
      _customerOrders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void addCustomerOrdersOnServer(
      String name,
      String email,
      String contact,
      String address,
      List<CartItem> cartProducts,
      double total,
      String userLocalId) {
    final url =
        'https://flutter-update-67f54.firebaseio.com/confirmedOrders.json?auth=$authToken';
    try {
      http.post(
        url,
        body: json.encode({
          'status': "Pending",
          'orderId': _customerOrderId,
          'dateTime': timeStop.toIso8601String(),
          'name': name,
          'email': email,
          'contact': contact,
          'address': address,
          'amount': total,
          'userId': userLocalId,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateStatus(
      String id, String localId, String orderId, String currentStatus) async {
    var url =
        'https://flutter-update-67f54.firebaseio.com/confirmedOrders/$id.json?auth=$authToken';
    try {
      await http.patch(
        url,
        body: json.encode({
          'status': currentStatus,
        }),
      );
      url =
          'https://flutter-update-67f54.firebaseio.com/orders/$localId/$orderId.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'status': currentStatus,
        }),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addBonusPoint(double amount, int previousPoint) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/bonusPoint/$userId/M1234567.json?auth=$authToken';
    double point = amount / 100;

    try {
      await http.put(url,
          body: json.encode(
            point.toInt() + previousPoint,
          ));
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchPoint() async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/bonusPoint/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extract = json.decode(response.body);
      if (extract == null) {
        _pointt = 2;
      } else {
        _pointt = extract['M1234567'];
      }
    } catch (error) {
      _pointt = 2;
      throw HttpException('Error occurs');
    }
    notifyListeners();
  }

  void addSuggestionReport(String email, String subject, String description) {
    final url =
        'https://flutter-update-67f54.firebaseio.com/suggestionAndReports.json?auth=$authToken';
    try {
      http.post(
        url,
        body: json.encode({
          'email': email,
          'subject': subject,
          'description': description,
        }),
      );
    } catch (error) {
      throw error;
    }
  }

  void addReturnForm(String email, String orderId, String productId,
      String contact, String address, String description) {
    final url =
        'https://flutter-update-67f54.firebaseio.com/returnProductsList.json?auth=$authToken';
    try {
      http.post(
        url,
        body: json.encode({
          'email': email,
          'orderId': orderId,
          'productId': productId,
          'contact': contact,
          'address': address,
          'description': description,
        }),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetReturnList() async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/returnProductsList.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ReturnClass> loadedData = [];
      extractedData.forEach((key, value) {
        loadedData.add(ReturnClass(
            id: key,
            email: value['email'],
            productId: value['productId'],
            contact: value['contact'],
            orderId: value['orderId'],
            address: value['address'],
            description: value['description']));
      });
      _returnProducts = loadedData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteReturnListItem(String id) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/returnProductsList/$id.json?auth=$authToken';
    final exIndex = _returnProducts.indexWhere((element) => element.id == id);
    var exProduct = _returnProducts[exIndex];
    _returnProducts.removeAt(exIndex);
    notifyListeners();
    final response = await http.delete(url);
    // 400 er upore means Error occurs
    if (response.statusCode >= 400) {
      _returnProducts.insert(exIndex, exProduct);
      notifyListeners();
      // its additional
      throw HttpException('Could not delete product');
    }
    exProduct = null;
  }

  Future<void> fetchAndSetStatistic() async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/statistic.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      _totalRevenue = extractedData['total'];
      _totalSell = extractedData['count'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateStatistic(double amount) async {
    final url =
        'https://flutter-update-67f54.firebaseio.com/statistic.json?auth=$authToken';
    try {
      await http.put(url,
          body: json.encode(
              {'total': _totalRevenue + amount, 'count': _totalSell + 1}));
    } catch (error) {
      throw error;
    }
  }
}
