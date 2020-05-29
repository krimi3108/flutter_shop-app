import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/addEditProductScreen.dart';
import '../Provider/product.dart';
import '../Provider/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
        radius: 30.0,
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditProductScreen.routeName,
                    arguments: product.id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context)
                      .deleteProduct(product.id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text("Item couldn;t deleted!"),
                  ));
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
