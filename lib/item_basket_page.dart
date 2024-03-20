import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/public/appbar.dart';

import 'constants.dart';

class ItemBasketPage extends StatefulWidget {

  ItemBasketPage({super.key});


  @override
  State<ItemBasketPage> createState() => _ItemBasketPage();



}


class _ItemBasketPage extends State<ItemBasketPage> {

  List<ProductDTO> basketList = [];
  int totalPrice = 0;


  void GET_basketList() async {
    Response response = await Dio().get("http://localhost:8080/basket_product");
    List<dynamic> responseData = response.data;
    List<ProductDTO> products = responseData.map((json) => ProductDTO.fromJson(json: json)).toList();

    print(products);
    setState(() {
      basketList = products;
      for (int i = 0; i < basketList.length; i++) {
        totalPrice += basketList[i].price! * basketList[i].amount!;
      }
    });

  }




  @override
  void initState() {
    super.initState();
    GET_basketList();
  }

  @override
  Widget build(BuildContext context) {
    String title = "장바구니 페이지";
    return Scaffold(
      appBar: pub_app(title),
      body: ListView.builder(
        itemCount: basketList.length,
        itemBuilder: (context, index) {
          return basketContainer(
              no: basketList[index].no ?? 0,
              title: basketList[index].title ?? "",
              mainImg: basketList[index].mainImg ?? "",
              price: basketList[index].price ?? 0,
              amount: basketList[index].amount ?? 0
          );
        }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: (){},
          child: Text("총 ${numberFormat.format(totalPrice)}원 결제하기"),
        ),
      ),
    );
  }

  Widget basketContainer({
    required int no,
    required String title,
    required String mainImg,
    required int price,
    required int amount
}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage( // 동일한 이미지일 경우 캐시에 저장된 이미지를 가져옴
            imageUrl: mainImg,
            width: MediaQuery.of(context).size.width * 0.3,
            fit: BoxFit.cover,
            placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
            },
            errorWidget: (context, url, error){
                return const Center(
                  child: Text("오류 발생"),
                );
            },
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            // flex: 1,
            // padding: const EdgeInsets.symmetric(
            //     horizontal: 15,
            //     vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  // textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text("${numberFormat.format(price)}원"),
                Row(
                  children: [
                    const Text('수량'),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove),
                    ),
                    Text("$amount"),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add)
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete)
                    ),
                  ],
                ),
                Text("합계: ${numberFormat.format(price * amount)}원"),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

