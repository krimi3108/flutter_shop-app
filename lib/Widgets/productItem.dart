
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/auth.dart';
import '../Provider/cart.dart';
import '../Provider/product.dart';
import '../Screens/productDetailScreen.dart';

class ProductItem extends StatelessWidget {
  // final Product product;

  // ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id)
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                // label: child,
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  product.isFavoriteState(
                    authData.token,
                    authData.userId,
                  );
                },
              ),
              // child: xyz...,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("\$${product.price}"),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(proData: product);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text("Item is added into cart successfully!"),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
