import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class ItemCheckoutPage extends StatefulWidget {

  ItemCheckoutPage({super.key});


  @override
  State<ItemCheckoutPage> createState() => _ItemCheckoutPage();

}

class _ItemCheckoutPage extends State<ItemCheckoutPage> {
  List<ProductDTO> basketList = [
    ProductDTO(
      no: 1,
      title: "아무거나",
      mainImg: "https://item.kakaocdn.net/do/aebede13eed766c14f8e46d68509586c7154249a3890514a43687a85e6b6cc82",
      price: 30000,
    ),
    ProductDTO(
      no: 2,
      title: "아무거나2",
      mainImg: "https://webudding.com/_next/image/?url=https%3A%2F%2Fd29hudvzbgrxww.cloudfront.net%2Fpublic%2Fproduct%2F20220905144129-ee57741b-6057-4a1a-8531-8e6dcb6315f7.jpg&w=3840&q=100",
      price: 30000,
    )
  ];

  List<Map<int, int>> quantityList =[
    {1:2},
    {2:3},
  ];

  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < basketList.length; i++) {
      totalPrice += basketList[i].price! * quantityList[i][basketList[i].no]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("결제시작 페이지"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: checkoutList.length,
        itemBuilder: (context, index) {
          return checkoutContainer(
              no: basketList[index].no ?? 0,
              title: basketList[index].title ?? "",
              mainImg: basketList[index].mainImg ?? "",
              price: basketList[index].price ?? 0,
              quantity: quantityList[index][basketList[index].no] ?? 0
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

  Widget checkoutContainer({
    required int no,
    required String title,
    required String mainImg,
    required int price,
    required int quantity
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("${numberFormat.format(price)}원"),
                Row(
                  children: [
                    const Text('수량'),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove),
                    ),
                    Text("$quantity"),
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
                Text("합계: ${numberFormat.format(price * quantity)}원"),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

