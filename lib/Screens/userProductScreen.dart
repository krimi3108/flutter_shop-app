import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './drawerScreen.dart';
import './addEditProductScreen.dart';
import '../Provider/products.dart';
import '../Widgets/userProductItem.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/produts";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context).items;

    return Scaffold(
        appBar: AppBar(
          title: Text("Your Products"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: DrawerScreen(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator(radius: 20.0)
                          : CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: (ctx, products, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: <Widget>[
                                  UserProductItem(product: products.items[i]),
                                  Divider(),
                                ],
                              );
                            },
                            itemCount: products.items.length,
                          ),
                        ),
                      )),
        ));
  }
}
