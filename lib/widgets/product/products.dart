import 'package:flutter/material.dart';
import 'package:food_orage_app/widgets/product/product_card.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scope-models/main.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('[Product Widget] build()');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) =>
          _buildProductList(model.allProducts),
    );
  }

  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }
}
