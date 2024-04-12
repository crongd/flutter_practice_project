

import 'package:flutter/material.dart';

import '../page/item_basket_page.dart';

PreferredSizeWidget? pub_app(title, context) {
  return AppBar(
    scrolledUnderElevation: 0,
    toolbarHeight: 40,
    title: Text(title, style: TextStyle(fontFamily: 'Jalnan'),),
    actions: [
      IconButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ItemBasketPage())
        );
      }, icon: Icon(Icons.shopping_cart))
    ],
    centerTitle: true,
  );
}
