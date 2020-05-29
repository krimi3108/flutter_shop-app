import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../Models/httpException.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken;
  String userId;

  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesOnly {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Product getProductby({String id}) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts([bool filterBy = false]) async {
    final filter = filterBy ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        "https://flutter-shopapp-60080.firebaseio.com/products.json?auth=$authToken&$filter";
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          "https://flutter-shopapp-60080.firebaseio.com/userFavorites/$userId.json?auth=$authToken";

      final favResponse = await http.get(url);
      final favResponseData = json.decode(favResponse.body);

      List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          price: double.parse(prodData["price"]),
          imageUrl: prodData["imageUrl"],
          isFavorite: favResponseData == null ? false : favResponseData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) {
    final url =
        "https://flutter-shopapp-60080.firebaseio.com/products.json?auth=$authToken";

    return http
        .post(url,
            body: json.encode({
              "title": product.title,
              "description": product.description,
              "price": product.price.toString(),
              "imageUrl": product.imageUrl,
              "creatorId": userId,
              // "isFavorite": product.isFavorite,
            }))
        .then((response) {
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)["name"], // DateTime.now().toString(),
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw (error);
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final url =
            "https://flutter-shopapp-60080.firebaseio.com/products/$id.json?auth=$authToken";
        await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "price": newProduct.price.toString(),
              "imageUrl": newProduct.imageUrl,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw (error);
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url =
          "https://flutter-shopapp-60080.firebaseio.com/products/$id.json?auth=$authToken";

      final index = _items.indexWhere((prod) => prod.id == id);
      final existingProduct = _items[index];
      _items.removeAt(index);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _items.insert(index, existingProduct);
        notifyListeners();
        throw HttpExpcetion("Not able to delete it");
      }
    } catch (error) {
      throw (error);
    }
  }
}
