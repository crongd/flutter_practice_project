import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/public/appbar.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/public/loginCheck.dart';
import 'package:flutter_practice_project/page/user_login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/page/item_basket_page.dart';

import '../public/constants.dart';

class ItemDetailsPage extends StatefulWidget {
  int no;

  ItemDetailsPage({super.key,
    required this.no,
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPage();
}

class _ItemDetailsPage extends State<ItemDetailsPage> {

  final storage = const FlutterSecureStorage();


  ProductDTO? productDTO;
  int? no;
  List<Widget> images = [];
  String? selectedOptionNo;
  String dropTitle = "옵션 선택";

  @override
  void initState() {
    super.initState();
    no = widget.no;
    product_get();
  }

  Widget image_to_widget(String imageUrl) {
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
  // void product_get() async {
  //   // print(no);
  //   Response response = await Dio().get('http://localhost:8080/product?no=$no');
  //   dynamic responseData = response.data;
  //   // print(responseData);
  //   ProductDTO resultData = ProductDTO.fromJson(json: responseData);
  //   // print(resultData);
  //
  //   productDTO = resultData;
  //
  //
  //   resultData.images?.forEach((img) {
  //     // print(img);
  //     setState(() {
  //       productDTO?.options ??= [];
  //       images.add(image(img));
  //     });
  //   });
  //   // print(images);
  //
  // }

  Future<ProductDTO> product_get() async {
    Response response = await Dio().get('http://$connectAddr:8080/product?no=$no');
    dynamic responseData = response.data;
    ProductDTO resultData = ProductDTO.fromJson(json: responseData);
    return resultData; // ProductDTO 반환
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
              selectedOptionNo = value;
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
      appBar: pub_app(title, context),

      body: FutureBuilder<ProductDTO> (
        future: product_get(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          } else {
            productDTO = snapshot.data; //데이터 업데이트
            images.clear();
            productDTO?.images?.forEach((image) {
              images.add(image_to_widget(image));
            });
            return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * 0.8,
                        // height: MediaQuery.of(context).size.height * 0.5,
                        imageUrl: productDTO!.mainImg!,
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
                        productDTO!.title!,
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
                              "${numberFormat.format(productDTO!.price)}원",
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
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: FilledButton(
          onPressed: () async {
            // 추후 장바구니 담는 로직 추가 예정
            if(await loginCheck()) {
              var formData = {
                "userId" : await storage.read(key: 'login'),
                "productNo" : no,
                "optionNo" : selectedOptionNo
              };

              print(formData);
              await Dio().post('http://$connectAddr:8080/shopCart_product',
                  options: Options(contentType: Headers.jsonContentType),
                  data: json.encode(formData)
              );

              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      content: Text("장바구니 담았는데 보러 갈래?"),
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ItemBasketPage())
                          );
                        }, child: Text("가자")),
                        TextButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("싫어")),
                      ],
                    );
                  });

            } else {
              // alert(context, "로그인이 필요한 시스템임");
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserLoginPage(no: no!, page: "detail",))
              );
            }
          },
          child: const Text("장바구니 담기"),
        ),
      ),
    );
  }

}

