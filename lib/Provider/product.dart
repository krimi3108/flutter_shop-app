import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void _setFavoriteVal(bool val) {
    isFavorite = val;
    notifyListeners();
  }

  void isFavoriteState(String authToken, String userId) async {
    final oldValue = isFavorite;
    _setFavoriteVal(!isFavorite);
    // isFavorite = !isFavorite;
    // notifyListeners();
    final url =
        "https://flutter-shopapp-60080.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken";
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        _setFavoriteVal(oldValue);
      }
    } catch (_) {
      _setFavoriteVal(oldValue);
    }
  }
}
