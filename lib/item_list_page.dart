import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/item_details_page.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import 'constants.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {

  List<ProductDTO> productList = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   test();
    // });
    get_product_list();
  }

  void get_product_list() async {
    Response response = await Dio().get("http://localhost:8080/product_list");
    // print(response);
    List<dynamic> responseData = response.data;
    List<ProductDTO> products = responseData.map((json) => ProductDTO.fromJson(json: json)).toList();

    products.asMap().forEach((key, value) {
      productList.add(value);
    });

    // print(productList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 리스트"),
        centerTitle: true,
      ),
      body: GridView.builder(
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

