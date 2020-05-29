import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_demo/HomeDrawer.dart';

import './cartScreen.dart';
import './drawerScreen.dart';
import '../Widgets/productGrid.dart';
import '../Widgets/badge.dart';
import '../Provider/cart.dart';
import '../Provider/products.dart';

enum ProductType {
  all,
  favorites,
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  var _isFavoriteOnly = false;
  var _isLoading = false;
  var _initFirst = true;

  @override
  void initState() {
    // .... To fetch the products we have 3 ways,
    // firt 2 are writing in initState or
    // last(3rd) is written in didchange method....

    // Provider.of<Products>(context, listen: false).fetchProducts().then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchProducts();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initFirst) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initFirst = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text("Products"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.value.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                _isFavoriteOnly = selectedValue == ProductType.favorites;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show All"),
                value: ProductType.all,
              ),
              PopupMenuItem(
                child: Text("Favorites"),
                value: ProductType.favorites,
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator(radius: 20.0)
                  : CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(8),
              child: ProductGrid(_isFavoriteOnly),
            ),
    );
  }
}
