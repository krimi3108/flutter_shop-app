import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Provider/orders.dart' as pOd;

class OrderItem extends StatefulWidget {
  final pOd.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isexpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: ListTile(
              title: Text(widget.order.amount.toString()),
              subtitle: Text(DateFormat.yMMMEd().format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_isexpanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _isexpanded = !_isexpanded;
                    print(_isexpanded);
                  });
                },
              ),
            ),
          ),
          if (_isexpanded)
            Column(
              children: <Widget>[
                Divider(height: 1, color: Colors.grey),
                Container(
                  color: Colors.grey.withOpacity(0.1),
                  height: min(widget.order.products.length * 60.0 + 40, 200),
                  child: ListView(
                    children: widget.order.products.map((prodData) {
                      return ListTile(
                        title: Text(prodData.title),
                        subtitle: Text("Qantity: ${prodData.quantity}"),
                        trailing: Text(prodData.price.toString()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
