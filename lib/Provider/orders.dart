import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String authToken;
  String userId;

  Orders(
    this.authToken,
    this.userId,
    this._orders,
  );

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fecthOrders() async {
    final url = "https://flutter-shopapp-60080.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final extractOrders = json.decode(response.body) as Map<String, dynamic>;
      if (extractOrders == null) {
        return;
      }
      List<OrderItem> loadedOrders = [];

      extractOrders.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData["amount"],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData["products"] as List<dynamic>)
                .map(
                  (cartData) => CartItem(
                    id: cartData["id"],
                    title: cartData["title"],
                    price: cartData["price"],
                    quantity: cartData["quantity"],
                  ),
                )
                .toList(),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrder({List<CartItem> products, double total}) async {
    final url = "https://flutter-shopapp-60080.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final timestamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            'dateTime': timestamp.toIso8601String(),
            "products": products
                .map((orderProd) => {
                      "id": orderProd.id,
                      "title": orderProd.title,
                      "price": orderProd.price,
                      "quantity": orderProd.quantity,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)["name"],
            amount: total,
            dateTime: timestamp,
            products: products,
          ));
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }
}
