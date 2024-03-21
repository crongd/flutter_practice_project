import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/public/appbar.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/item_basket_page.dart';
import 'package:flutter_practice_project/item_list_page.dart';

import 'constants.dart';

class ItemDetailsPage extends StatefulWidget {
  int no;
  String title;
  String mainImg;
  int price;

  ItemDetailsPage({super.key,
    required this.no,
    required this.title,
    required this.mainImg,
    required this.price
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPage();
}

class _ItemDetailsPage extends State<ItemDetailsPage> {

  ProductDTO? productDTO;
  int no = 0;
  List<Widget> images = [];
  String? selectedOptionNo;
  String dropTitle = "옵션 선택";

  @override
  void initState() {
    super.initState();
    no = widget.no;
    product_get();

  }

  Widget image(imageUrl) {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.5,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            )
        );
      },
      errorWidget: (context, url, error) {
        return const Center(
          child: Text("오류 발생"),
        );
      },
    );
  }

  
  // 1개의 상품정보
  void product_get() async {
    // print(no);
    Response response = await Dio().get('http://localhost:8080/product?no=$no');
    dynamic responseData = response.data;
    // print(responseData);
    ProductDTO resultData = ProductDTO.fromJson(json: responseData);
    // print(resultData);

    productDTO = resultData;


    resultData.images?.forEach((img) {
      // print(img);
      setState(() {
        productDTO?.options ??= [];
        images.add(image(img));
      });
    });
    // print(images);

  }

  Widget dropdown() {
    if(productDTO?.options?.length == 0) {
      return Container();
    } else {
      return DropdownButton(
          value: selectedOptionNo,
          hint: Text("$dropTitle"),
          items: productDTO?.options!.map((option) {
            return DropdownMenuItem(
                value: option.no.toString(),
                child: Text("${option.name}")
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              dropTitle = productDTO!.options!.singleWhere((element) => element.no == int.parse(value!)).name!;
              print(dropTitle);
            });
          }
      );
    }
  }

  // void cart_product() async {
  //   await Dio().post("http://localhost:8080/shopCart_product",
  //     data: data);
  //
  //
  // }


  @override
  Widget build(BuildContext context) {
    String title = "제품 상세 페이지";
    return Scaffold(
      appBar: pub_app(title),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.5,
                imageUrl: widget.mainImg,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  );
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Text("오류 발생"),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.title,
                textScaleFactor: 1.5,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dropdown(),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    "${numberFormat.format(widget.price)}원",
                    textScaleFactor: 1.3,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: images,
              ),
            )
          ],
        )
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            // 추후 장바구니 담는 로직 추가 예정
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ItemBasketPage();
            }));
          },
          child: const Text("장바구니 담기"),
        ),
      ),
    );
  }

}

