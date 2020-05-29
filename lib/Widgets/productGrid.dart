import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/products.dart';
import '../Widgets/productItem.dart';

class ProductGrid extends StatelessWidget {
  final isFav;
  
  ProductGrid(this.isFav);
  
  @override
  Widget build(BuildContext context) {
    final products = isFav ? Provider.of<Products>(context).favoritesOnly : Provider.of<Products>(context).items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (ctx) => products[i],
        value: products[i],
        child: ProductItem(),
        // child: ProductItem(
        //   products[i],
        // ),
      ),
      itemCount: products.length,
    );
  }
}
