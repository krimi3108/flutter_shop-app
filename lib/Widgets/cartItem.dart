import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/cart.dart';

class CartTile extends StatelessWidget {
  final CartItem selectedItem;
  final String productId;

  CartTile({this.selectedItem, this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(selectedItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (selectedItem) {
        Provider.of<Cart>(context).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to delete item from cart?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  return Navigator.of(context).pop(true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              child: CircleAvatar(
                radius: 30,
                child: Text(
                  "\$${selectedItem.price}",
                ),
              ),
            ),
          ),
          title: Text(
            selectedItem.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          subtitle: Text(
              "Total ${(selectedItem.quantity * selectedItem.price).toStringAsFixed(2)}"),
          trailing: Text("${selectedItem.quantity}x"),
        ),
      ),
    );
  }
}
