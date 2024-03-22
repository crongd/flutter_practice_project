

import 'package:flutter/material.dart';

void alert(context, String text) async {
  showDialog(context: context, builder: (BuildContext ctx) {
    return AlertDialog(
      content: Text(text),
      actions: [
        Center(
          child: TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("확인")),
        )
      ],
    );
  });
}