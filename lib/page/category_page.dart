import 'package:flutter_practice_project/public/appbar.dart';
import 'package:flutter_practice_project/public/constants.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/main.dart';

import '../models/CategoryDTO.dart';
import 'item_basket_page.dart';
import 'item_list_page.dart';


class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  List<CategoryDTO> categoryList = [];
  List<CategoryDTO> rowCategoryList = [];
  int selectedIndex = 0;
  String title = '카테고리';

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GET_category();

  }

  void GET_category() async {
    Response response = await Dio().get('http://$connectAddr:8080/all_category');
    List<dynamic> responseData = response.data;
    setState(() {
      categoryList = responseData.map((json) => CategoryDTO.fromJson(json: json)).toList();
      rowCategoryList = categoryList[selectedIndex].categorys!;
    });
    // print("categoryList $categoryList");
    print("category[cate] ${categoryList[0].categorys}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        title: isSearching
            ? Row( // 검색 모드일 때 검색창과 검색 버튼을 표시
          children: [
            Expanded(
              child: TextField(
                controller: _searchController, // 검색 컨트롤러 설정
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "검색...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black),
                onSubmitted: (value) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ItemListPage(no: 0, search: value,))
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                print(_searchController.text);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ItemListPage(no: 0, search: _searchController.text,))
                );
              },
            )
          ],
        )
            : Text(title, style: TextStyle(fontFamily: 'Jalnan'),), // 기본 모드일 때 타이틀 표시
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    // 검색 모드 종료 시 검색어 초기화
                    _searchController.clear();
                  }
                  isSearching = !isSearching; // 검색 모드 상태 변경
                });
              },
              icon: Icon(isSearching ? Icons.cancel : Icons.search) // 검색 모드에 따라 아이콘 변경
          ),
          if(!isSearching) // 검색 모드가 아닐 때만 장바구니 아이콘 표시
            IconButton(onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ItemBasketPage())
              );
            }, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: Container(
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: List.generate(categoryList.length, (index) {
                      return top_category_Container(
                          no: categoryList[index].no ?? 0,
                          name: categoryList[index].name ?? "",
                          parentNo: categoryList[index].parentNo ?? 0,
                          level: categoryList[index].level ?? 0,
                          index: index
                      );
                    }),
                  ),
                )
            ),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey,
                  child: Column(
                    children: List.generate(rowCategoryList.length, (index) {
                      return row_category_Container(
                          no: rowCategoryList[index].no ?? 0,
                          name: rowCategoryList[index].name ?? "",
                          parentNo: rowCategoryList[index].parentNo ?? 0,
                          level: rowCategoryList[index].level ?? 0,
                          index: index
                      );
                    }),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }


  Widget top_category_Container({
    required int no,
    required String name,
    required int parentNo,
    required int level,
    required int index
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            setState(() {
              selectedIndex = index;
              rowCategoryList = categoryList[index].categorys!;
            });
          },
          style: TextButton.styleFrom(
            fixedSize: Size.fromHeight(double.infinity),
            foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
            backgroundColor: selectedIndex == index ? Colors.grey : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide.none,
            ),
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
          child: Text('$name', style: TextStyle(fontSize: 17, fontFamily: 'Cafe'),)
      )
    );
  }

  Widget row_category_Container({
    required int no,
    required String name,
    required int parentNo,
    required int level,
    required int index
  }) {
    return Container(
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                mainStatus = 1;
                return MarketPage(no: no, title: name,);
              })
            );
          },
          child: Text("$name", style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'Cafe'),)
      ),
    );
  }

}


