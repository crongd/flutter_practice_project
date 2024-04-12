import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/page/item_basket_page.dart';
import 'package:flutter_practice_project/page/item_details_page.dart';
import 'package:flutter_practice_project/main.dart';
import 'package:flutter_practice_project/page/main_page.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/public/loginCheck.dart';
import 'package:flutter_practice_project/page/category_page.dart';
import 'package:flutter_practice_project/public/search.dart';
import 'package:flutter_practice_project/page/user_login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/CategoryDTO.dart';

import 'package:dio/dio.dart';

import '../public/constants.dart';

class ItemListPage extends StatefulWidget {
  int no;
  String? search;
  String? title;

  ItemListPage({super.key,
    required this.no,
    this.search,
    this.title
  });

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<ProductDTO> productList = [];
  List<CategoryDTO> categoryList = [];
  // String? selectedCategory;
  int cateNo = 0;
  // String categoryName = "카테고리 선택";
  String title = "제품 리스트 페이지";


  @override
  void initState() {
    super.initState();
    mainStatus = 0;
    cateNo = widget.no;
    get_product_list();
    print(widget.search);
    if (widget.title != null) {
      title = widget.title!;
    }
  }

  void get_product_list() async {
    if(widget.search == null || widget.search == "") {
      Response respProduct = await Dio().get("http://$connectAddr:8080/product_list?no=$cateNo");
      // print(response);
      List<dynamic> productData = respProduct.data;
      List<ProductDTO> products = productData.map((json) => ProductDTO.fromJson(json: json)).toList();

      setState(() {
        productList = products;
      });

    } else {
      Response respProduct = await Dio().get("http://$connectAddr:8080/product_search_list?no=$cateNo&search=${widget.search}");
      // print(response);
      List<dynamic> productData = respProduct.data;
      List<ProductDTO> products = productData.map((json) => ProductDTO.fromJson(json: json)).toList();

      setState(() {
        productList = products;
      });
    }

    if(widget.no != 0) {
      Response respCategory = await Dio().get("http://$connectAddr:8080/children_category?no=$cateNo");
      List<dynamic> categoryData = respCategory.data;
      List<CategoryDTO> categories = categoryData.map((json) => CategoryDTO.fromJson(json: json)).toList();

      setState(() {
        categoryList = categories ?? [];
      });
    }

    widget.search = "";
  }

  // Widget dropdown() {
  //   if(categoryList.isEmpty) {
  //     return const SizedBox(width: 0, height: 0,);
  //   } else {
  //     return DropdownButton(
  //         value: selectedCategory,
  //         hint: Text("$categoryName"),
  //         items: categoryList.map((category) {
  //           return DropdownMenuItem(
  //               value: category.no.toString(),
  //               child: Text("${category.name}")
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           cateNo = int.parse(value!);
  //           setState(() {
  //             get_product_list();
  //             categoryName = categoryList.singleWhere((element) => element.no == int.parse(value)).name!;
  //             // categoryList.forEach((element) {
  //             //   print(element.no);
  //             // });
  //             // print("value" + value);
  //             print(categoryName);
  //           });
  //         }
  //     );
  //   }
  // }



  // void loginStatus() async {
  //   loginIcon = [];
  //   print("loginStatus");
  //   print(await loginCheck());
  //   if(await loginCheck()) {
  //     setState(() {
  //       loginIcon.add(TextButton(onPressed: (){
  //         final storage = new FlutterSecureStorage();
  //         storage.delete(key: 'login');
  //         Navigator.of(context).pop();
  //         Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => ItemListPage(no: widget.no))
  //         );
  //       }, child: Text('로그아웃'),));
  //     });
  //   } else {
  //     setState(() {
  //       loginIcon.add(TextButton(onPressed: (){
  //         setState(() {
  //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserLoginPage(no: widget.no, page: "list",)));
  //         });
  //       }, child: Text('로그인')));
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        title: Text(title, style: TextStyle(fontFamily: 'Jalnan'),),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();

        },
          icon: Icon(Icons.navigate_before),
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.search)
          ),
          IconButton(onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ItemBasketPage())
            );
          }, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:GridView.builder(
                itemCount: productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.9,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return productContainer(
                    no: productList[index].no ?? 0,
                    title: productList[index].title ?? "",
                    mainImg: productList[index].mainImg ?? "",
                    price: productList[index].price ?? 0,
                  );
                },
              ),
          )
        ],
      )
      // GridView.builder(
      //   itemCount: productList.length,
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     childAspectRatio: 0.9,
      //     crossAxisCount: 2),
      //   itemBuilder: (context, index) {
      //     return productContainer(
      //       no: productList[index].no ?? 0,
      //       title: productList[index].title ?? "",
      //       mainImg: productList[index].mainImg ?? "",
      //       price: productList[index].price ?? 0,
      //     );
      //   },
      // ),
    );
  }

  Widget productContainer({
    required int no,
    required String title,
    required String mainImg,
    required int price
}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemDetailsPage(no: no);
        }));
      },
      child: Column(
        children: [
          CachedNetworkImage(
              height: 150,
              fit: BoxFit.cover,
              imageUrl: mainImg,
          placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
          },
          errorWidget: (context, url, error) {
                return const Center(
                  child: Text(("오류발생")),
                );
          },
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            child: Text("${numberFormat.format(price)}원"),
          ),
        ],
      ),
    );
  }
}

