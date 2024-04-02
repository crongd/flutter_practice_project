import 'package:flutter_practice_project/item_basket_page.dart';
import 'package:flutter_practice_project/item_list_page.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/public/loginCheck.dart';

import '../models/CategoryDTO.dart';
import '../user_login_page.dart';


class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  List<CategoryDTO> categoryList = [];

  @override
  void initState() {
    super.initState();
    GET_parent_category();

  }

  void GET_parent_category() async {
    Response response = await Dio().get('http://192.168.2.3:8080/parent_category');
    List<dynamic> responseData = response.data;
    setState(() {
      categoryList = responseData.map((json) => CategoryDTO.fromJson(json: json)).toList();
    });
    print(categoryList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카테고리"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return navContainer(
              no: categoryList[index].no ?? 0,
              name: categoryList[index].name ?? "",
              parent_no: categoryList[index].parent_no ?? 0,
              level: categoryList[index].level ?? 0
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () async {
            if(await loginCheck()) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ItemBasketPage())
              );
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserLoginPage(no: 0, page: "list",))
              );
            }

          },
          child: const Text("장바구니"),
        ),
        
      ),
    );
  }


  Widget navContainer({
    required int no,
    required String name,
    required int parent_no,
    required int level
}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 50,
            child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ItemListPage(no: no,);
                  }));
                  // pop 하고 실행?
                  // 바로실행하면 스택에 올라가지 않나 뒤로가기 하면 이 화면이 나오고;
                },
                child: Text(name)),
          ),
        ],
      ),

    );
  }

}


