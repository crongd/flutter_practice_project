import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/public/appbar.dart';
import 'package:flutter_practice_project/item_payment_page.dart';
import 'package:kpostal/kpostal.dart';

import 'constants.dart';

class ItemPaymentPage extends StatefulWidget {

  ItemPaymentPage({super.key});


  @override
  State<ItemPaymentPage> createState() => _ItemPaymentPage();



}


class _ItemPaymentPage extends State<ItemPaymentPage> {
  TextEditingController buyerNameController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverZipController = TextEditingController();
  TextEditingController receiverAddress1Controller = TextEditingController();
  TextEditingController receiverAddress2Controller = TextEditingController();
  TextEditingController userPwdController = TextEditingController();
  TextEditingController userConfirmPwdController = TextEditingController();
  TextEditingController cardNoController = TextEditingController();
  TextEditingController cardAuthController = TextEditingController();
  TextEditingController cardExpiredDateController = TextEditingController();
  TextEditingController cardPwdTwoDigitsController = TextEditingController();

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
    String title = "결제 페이지";
    return Scaffold(
      appBar: pub_app(title),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: basketList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return paymentContainer(
                  no: basketList[index].no ?? 0,
                  title: basketList[index].title ?? "",
                  mainImg: basketList[index].mainImg ?? "",
                  option: basketList[index].options?[0].name ?? "",
                  price: basketList[index].price ?? 0,
                  amount: basketList[index].amount ?? 0
                );
              }
            ),
            Text(
                '결제 정보',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            buyerNameTextField(),
            buyerEmailTextField(),
            buyerPhoneTextField(),
            receiverNameTextField(),
            receiverPhoneTextField(),
            receiverZipTextField(),
            receiverAddress1TextField(),
            receiverAddress2TextField(),
            userPwdTextField(),
            userConfirmPwdTextField(),
            cardNoTextField(),
            cardAuthTextField(),
            cardExpiredDateTextField(),
            cardPwdTwoDigitsTextField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ItemPaymentPage())
            );
          },
          child: Text("총 ${numberFormat.format(totalPrice)}원 결제요청"),
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

  Widget paymentContainer({
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
                    Text("$amount"),
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

  Widget buyerNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: buyerNameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "주문자명",
        ),
      ),
    );
  }

  Widget buyerEmailTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: buyerEmailController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "주문자 이메일",
        ),
      ),
    );
  }

  Widget buyerPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: buyerPhoneController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "주문자 휴대전화",
        ),
      ),
    );
  }

  Widget receiverNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverNameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "받는 사람 이름",
        ),
      ),
    );
  }

  Widget receiverPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverPhoneController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "받는 사람 휴대폰 번호"
        ),
      ),
    );
  }


  Widget receiverZipTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
                readOnly: true,
                controller: receiverZipController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "우편번호",
                ),
              )
          ),
          const SizedBox(width: 15,),
          FilledButton(
            onPressed: () {
              //우편번호 초이스
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KpostalView(
                      callback: (Kpostal result) {
                        receiverZipController.text = result.postCode;
                        receiverAddress1Controller.text = result.address;
                      },
                    )
                )
              );
            },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )
              ),
            child: const Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Text("우번편호 찾기"),
            )
          ),
        ],
      )
    );
  }

  Widget receiverAddress1TextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        controller: receiverAddress1Controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "기본 주소",
        ),
      ),
    );
  }


  Widget receiverAddress2TextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverAddress2Controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "상세 주소",
        ),
      ),
    );
  }

  Widget userPwdTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: userPwdController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "비회원 주문조회 비밀번호",
        ),
      ),
    );
  }


  Widget userConfirmPwdTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: userConfirmPwdController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "비회원 주문조회 비밀번호 확인",
        ),
      ),
    );
  }

  Widget cardNoTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardNoController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드번호",
        ),
      ),
    );
  }

  Widget cardAuthTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardAuthController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드명의자 주민번호 앞자리",
        ),
      ),
    );
  }

  Widget cardExpiredDateTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardExpiredDateController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드 만료일",
        ),
      ),
    );
  }


  Widget cardPwdTwoDigitsTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardPwdTwoDigitsController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드 비밀번호 앞2자리",
        ),
      ),
    );
  }
}

