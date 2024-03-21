import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/item_details_page.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/public/nav.dart';
import '../models/CategoryDTO.dart';

import 'package:dio/dio.dart';

import 'public/appbar.dart';
import 'constants.dart';

class ItemListPage extends StatefulWidget {
  int no;

  ItemListPage({super.key,
    required this.no
  });

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {

  List<ProductDTO> productList = [];
  List<CategoryDTO> categoryList = [];
  String? selectedCategory;


  @override
  void initState() {
    super.initState();
    get_product_list();
  }

  void get_product_list() async {
    Response respProduct = await Dio().get("http://localhost:8080/product_list?no=${widget.no}");
    Response respCategory = await Dio().get("http://localhost:8080/children_category?no=${widget.no}");
    // print(response);
    List<dynamic> productData = respProduct.data;
    List<ProductDTO> products = productData.map((json) => ProductDTO.fromJson(json: json)).toList();

    List<dynamic> categoryData = respCategory.data;
    List<CategoryDTO> categories = categoryData.map((json) => CategoryDTO.fromJson(json: json)).toList();

    setState(() {
        productList = products;
    });

    setState(() {
      categoryList = categories;
    });
    // print(categoryList);
    // print(productList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("제품 리스트 페이지"),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen()));
        },
          icon: Icon(Icons.menu),
        ),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.login))],
      ),
      body: Column(
        children: [
          DropdownButton(
            value: selectedCategory,
            hint: Text("카테고리 선택"),
            items: categoryList.map((category) {
              return DropdownMenuItem(
                value: category.no.toString(),
                child: Text("${category.name}")
              );
            }).toList(),
            onChanged: (value) {

            }
          ),
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
          return ItemDetailsPage(no: no, title: title, mainImg: mainImg, price: price);
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

