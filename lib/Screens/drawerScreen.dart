import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/userProductScreen.dart';
import '../Screens/orderScreen.dart';

import '../Provider/auth.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 0,
              left: 10,
              right: 10,
            ),
            child: Text(
              "E-Commerce!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          buildListTile(
            icon: Icons.shopping_cart,
            title: "Shop",
            handler: () => Navigator.of(context).pushNamed("/"),
          ),
          buildListTile(
            icon: Icons.clear_all,
            title: "Order",
            handler: () =>
                Navigator.of(context).pushNamed(OrderScreen.routeName),
          ),
          buildListTile(
            icon: Icons.edit,
            title: "Products",
            handler: () =>
                Navigator.of(context).pushNamed(UserProductScreen.routeName),
          ),
          buildListTile(
              icon: Icons.exit_to_app,
              title: "Logout",
              handler: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');

                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }

  ListTile buildListTile({IconData icon, String title, Function handler}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(title,
          style: TextStyle(
            fontSize: 20,
          )),
      onTap: handler,
    );
  }
}
