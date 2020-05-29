import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Screens/productDetailScreen.dart';
import './Screens/addEditProductScreen.dart';
import './Screens/productListScreen.dart';
import './Screens/userProductScreen.dart';
import './Screens/splash_screen.dart';
import './Screens/authScreen.dart';
import './Screens/cartScreen.dart';
import './Screens/orderScreen.dart';

import './Provider/products.dart';
import './Provider/cart.dart';
import './Provider/orders.dart';
import './Provider/auth.dart';

void main() => runApp(ShopApp());

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProd) => Products(
            auth.token,
            auth.userId,
            previousProd == null ? [] : previousProd.items,
          ),
          create: null,
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Products(),
        //   // value: Products(),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOreder) => Orders(
            auth.token,
            auth.userId,
            previousOreder == null ? [] : previousOreder.orders,
          ),
          create: null,
        )
        // ChangeNotifierProvider(
        //   create: (ctx) => Orders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.white,
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(fontFamily: "Raleway"),
                  )),
          home: auth.isAuth
              ? ProductListScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            AddEditProductScreen.routeName: (ctx) => AddEditProductScreen(),
          },
        ),
      ),
    );
  }
}
