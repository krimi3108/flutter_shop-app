import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './drawerScreen.dart';
import '../Widgets/orderItem.dart';
import '../Provider/orders.dart' show Orders;

class OrderScreen extends StatelessWidget {
  static const routeName = "/order-screen";

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context).orders;
    // final showDrawer =
        // ModalRoute.of(context).settings.arguments as bool ?? true;
print("rebuidling");
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      // drawer: showDrawer ? DrawerScreen() : null,
      drawer: DrawerScreen(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fecthOrders(),
          builder: (ctx, loadingStatus) {
            if (loadingStatus.connectionState == ConnectionState.waiting) {
              return Center(
                child: Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              );
            } else {
              if (loadingStatus.error != null) {
                return Center(child: Text("Some error has occured!"));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, _) => ListView.builder(
                    itemBuilder: (ctx, i) {
                      return OrderItem(orderData.orders[i]);
                    },
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          }),
    );
  }
}
