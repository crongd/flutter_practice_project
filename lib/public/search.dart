

import 'package:flutter/material.dart';
import 'package:flutter_practice_project/item_list_page.dart';

void search_bar(context, no) {
  showDialog(context: context, builder: (BuildContext ctx) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchBar(
            hintText: '검색어를 입력하세요',
            trailing: [Icon(Icons.search)],
            shadowColor: MaterialStatePropertyAll(Colors.black),
            onSubmitted: (value) {
              print(value);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ItemListPage(no: no, search: value,))
              );
            },
        ),
        ],
      )



    );
  });
}