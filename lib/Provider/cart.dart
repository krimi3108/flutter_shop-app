import 'package:flutter/material.dart';

import '../Provider/product.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get value {
    return _items.length;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    _items.forEach((key, item) {
      totalAmount += item.price * item.quantity;
    });
    return totalAmount;
  }

  void addItem({Product proData}) {
    if (_items.containsKey(proData.id)) {
      _items.update(
        proData.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        proData.id,
        () => CartItem(
            id: DateTime.now().toString(),
            title: proData.title,
            price: proData.price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: existingItem.quantity - 1,
              ));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
