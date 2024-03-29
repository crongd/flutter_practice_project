import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/public/appbar.dart';
import 'package:flutter_practice_project/item_payment_page.dart';

import 'constants.dart';

class ItemBasketPage extends StatefulWidget {

  ItemBasketPage({super.key});


  @override
  State<ItemBasketPage> createState() => _ItemBasketPage();



}


class _ItemBasketPage extends State<ItemBasketPage> {

  List<ProductDTO> basketList = [];
  int totalPrice = 0;

  final storage = const FlutterSecureStorage();


  void GET_basketList() async {
    Response response = await Dio().get("http://192.168.219.106:8080/basket_product/${await storage.read(key: 'login')}");
    List<dynamic> responseData = response.data;
    List<ProductDTO> products = responseData.map((json) => ProductDTO.fromJson(json: json)).toList();

    setState(() {
      basketList = products;
      for (int i = 0; i < basketList.length; i++) {
        totalPrice += basketList[i].price! * basketList[i].amount!;
      }
    });
    print(basketList);
    // if(basketList.isEmpty) {
    //   basketList.add()
    // }

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
              option: basketList[index].options?[0].name ?? "",
              price: basketList[index].price ?? 0,
              amount: basketList[index].amount ?? 0
          );
        }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ItemPaymentPage())
            );
          },
          child: Text("총 ${numberFormat.format(totalPrice)}원 결제하기"),
        ),
      ),
    );
  }

  Widget option_widget(option) {
    if(option == "") {
      return SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Text('옵션: ${option}');
    }
  }

  Widget basketContainer({
    required int no,
    required String title,
    required String mainImg,
    required String option,
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
                option_widget(option),
                Row(
                  children: [
                    const Text('수량'),
                    IconButton(
                      onPressed: () {
                        if(amount > 1) {
                          var data = {
                            "no" : no,
                            "amount" : amount - 1
                          };

                          Dio().patch('http://192.168.219.106:8080/shpCart_amount_update',
                            data: data
                          );

                          setState(() {
                            basketList[basketList.indexWhere((element) => element.no == no)].amount = amount - 1;
                            totalPrice = 0;
                            for (int i = 0; i < basketList.length; i++) {
                              totalPrice += basketList[i].price! * basketList[i].amount!;
                            }
                          });

                        } else {
                          alert(context, "수량은 0이 될 수 없다");
                        }

                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text("$amount"),
                    IconButton(
                        onPressed: () {
                          print("+ 들어옴");
                          var data = {
                            "no" : no,
                            "amount" : amount + 1
                          };

                          Dio().patch('http://192.168.219.106:8080/shpCart_amount_update',
                              data: data
                          );

                          setState(() {
                            basketList[basketList.indexWhere((element) => element.no == no)].amount = amount + 1;
                            totalPrice = 0;
                            for (int i = 0; i < basketList.length; i++) {
                              totalPrice += basketList[i].price! * basketList[i].amount!;
                            }
                          });


                        },
                        icon: const Icon(Icons.add)
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  content: Text("진짜 삭제할래?"),
                                  actions: [
                                    TextButton(onPressed: () {
                                      var data = {
                                        "no" : no
                                      };

                                      Dio().delete('http://192.168.219.106:8080/shopCart_delete',
                                          data: data
                                      );
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ItemBasketPage())
                                      );
                                    }, child: Text("ㅇㅋ")),
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: Text("ㄴㄴ")),
                                  ],
                                );
                              });


                        },
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

