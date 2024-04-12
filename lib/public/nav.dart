import 'package:flutter_practice_project/item_basket_page.dart';
import 'package:flutter_practice_project/item_list_page.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/main.dart';
import 'package:flutter_practice_project/public/loginCheck.dart';
import 'package:flutter_practice_project/public/my_page.dart';

import '../models/CategoryDTO.dart';
import '../user_login_page.dart';


class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  List<CategoryDTO> categoryList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    GET_parent_category();

  }

  void GET_parent_category() async {
    Response response = await Dio().get('http://192.168.2.3:8080/all_category');
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
        title: Text(
          "카테고리",
          style: TextStyle(
            fontFamily: 'Jalnan',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child:
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(categoryList.length, (index) {
                          return top_category_Container(
                              no: categoryList[index].no ?? 0,
                              name: categoryList[index].name ?? "",
                              parent_no: categoryList[index].parentNo ?? 0,
                              level: categoryList[index].level ?? 0,
                              index: index
                          );
                        }),
                      ),
                    )
                )
            ),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey,

                )
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: FilledButton(
      //     onPressed: () async {
      //       if(await loginCheck()) {
      //         Navigator.of(context).pop();
      //         Navigator.of(context).push(
      //             MaterialPageRoute(builder: (context) => ItemBasketPage())
      //         );
      //       } else {
      //         Navigator.of(context).push(
      //             MaterialPageRoute(builder: (context) => UserLoginPage(no: 0, page: "list",))
      //         );
      //       }
      //
      //     },
      //     child: const Text("장바구니"),
      //   ),
      //
      // ),
    );
  }


  Widget top_category_Container({
    required int no,
    required String name,
    required int parent_no,
    required int level,
    required int index
}) {
    return Container(
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            setState(() {
              selectedIndex = index;
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: selectedIndex == index ? Colors.grey : Colors.white,
            primary: selectedIndex == index ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent;
                }
                return null;
              },
            ),
          ),
          child: Text('$name')
      )
    );
  }

}


