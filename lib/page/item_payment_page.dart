import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/page/port_one_payment_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice_project/public/appbar.dart';
import 'package:kpostal/kpostal.dart';
import 'package:flutter_practice_project/public/basic_dialog.dart';
import 'package:flutter_practice_project/page/item_order_result_page.dart';
import 'package:iamport_flutter/iamport_payment.dart';

import '../public/constants.dart';

class ItemPaymentPage extends StatefulWidget {
  List<ProductDTO> list;

  ItemPaymentPage({super.key, required this.list});


  @override
  State<ItemPaymentPage> createState() => _ItemPaymentPage();



}


class _ItemPaymentPage extends State<ItemPaymentPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController buyerNameController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverZipController = TextEditingController();
  TextEditingController receiverAddress1Controller = TextEditingController();
  TextEditingController receiverAddress2Controller = TextEditingController();
  TextEditingController cardNoController = TextEditingController();
  TextEditingController cardAuthController = TextEditingController();
  TextEditingController cardExpiredDateController = TextEditingController();
  TextEditingController cardPwdTwoDigitsController = TextEditingController();
  TextEditingController depositNameController = TextEditingController();

  // 결제수단 옵션 선택 변수
  final List<String> paymentMethodList = [
    '결제수단선택',
    '카드 결제',
    '무통장 입금'
  ];

  String selectedPaymentMethod = '결제수단선택';

  List<ProductDTO> basketList = [];
  int totalPrice = 0;
  int totalAmount = 0;

  final storage = const FlutterSecureStorage();


  void GET_basketList() async {
    // Response response = await Dio().get("http://192.168.2.3:8080/basket_product/${await storage.read(key: 'login')}");
    // List<dynamic> responseData = response.data;
    // List<ProductDTO> products = responseData.map((json) => ProductDTO.fromJson(json: json)).toList();
    basketList = widget.list;
    setState(() {
      // basketList = products;
      for (int i = 0; i < basketList.length; i++) {
        totalPrice += basketList[i].price! * basketList[i].amount!;
        totalAmount += basketList[i].amount!;
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
    String title = "결제 페이지";
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 페이지', style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage( // 동일한 이미지일 경우 캐시에 저장된 이미지를 가져옴
                    imageUrl: basketList[0].mainImg.toString(),
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
                          "${basketList[0].title}",
                          // textScaleFactor: 1.2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("외 ${basketList.length - 1} 개",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text("${numberFormat.format(basketList[0].price)}원"),
                        Row(
                          children: [
                            const Text('총 수량: '),
                            Text("${totalAmount}"),
                          ],
                        ),
                        Text("합계: ${numberFormat.format(totalPrice)}원"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
                '결제 정보',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            Form(
              key: formKey,
                child: Column(
                  children: [
                    inputTextField(currentController: buyerNameController, currentHintText: "주문자명"),
                    inputTextField(currentController: buyerEmailController, currentHintText: "주문자 이메일"),
                    inputTextField(currentController: buyerPhoneController, currentHintText: "주문자 휴대전화(숫자만 입력)", numberOnly: true),
                    inputTextField(currentController: receiverNameController, currentHintText: "수령자명"),
                    inputTextField(currentController: receiverPhoneController, currentHintText: "수령자 휴대전화(숫자만 입력)", numberOnly: true),
                    receiverZipTextField(),
                    inputTextField(currentController: receiverAddress1Controller, currentHintText: "기본 주소", isReadOnly: true),
                    inputTextField(currentController: receiverAddress2Controller, currentHintText: "상세 주소"),
                    paymentMethodDropdownButton(),
                    if (selectedPaymentMethod == "카드 결제")
                      Column(children: [
                        inputTextField(currentController: cardNoController, currentHintText: "카드 번호"),
                        inputTextField(
                            currentController: cardAuthController,
                            currentHintText: "카드명의자 주민번호 앞자리 or 사업자 번호",
                            currentMaxLength: 10),
                        inputTextField(
                            currentController: cardExpiredDateController,
                            currentHintText: "카드 만료일 (YYYYMM)",
                            currentMaxLength: 6
                        ),
                        inputTextField(
                            currentController: cardPwdTwoDigitsController,
                            currentHintText: "카드 비밀번호 앞 2자리",
                            currentMaxLength: 2
                        ),
                      ],
                      ),
                    if(selectedPaymentMethod == "무통장 입금")
                      inputTextField(
                        currentController: depositNameController,
                        currentHintText: "입금자명",
                      )
                  ],
                )
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: (){
            if (formKey.currentState!.validate()) {
              if (selectedPaymentMethod == "결제수단선택") {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return BasicDialog(
                          content: "결제수단 선택하셈",
                          buttonText: "닫기",
                          buttonFunction: () => Navigator.of(context).pop()
                      );
                    });
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    Payment(
                      amount: totalPrice,
                      productName: "${basketList[0].title} 외 ${basketList.length} 개",
                      buyerName: buyerNameController.text,
                      buyerTel: buyerPhoneController.text,
                      buyerPostcode: receiverZipController.text,
                      buyerAddr: receiverAddress1Controller.text + receiverAddress2Controller.text,
                    )
                )
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) {
              //     return const ItemOrderResultPage();
              //   }
              //   )
              // );
            }
          },
          child: Text("총 ${numberFormat.format(totalPrice)}원 결제요청"),
        ),
      ),
    );
  }

  // Widget option_widget(option) {
  //   if(option == "") {
  //     return SizedBox(
  //       height: 0,
  //       width: 0,
  //     );
  //   } else {
  //     return Text('옵션: ${option}');
  //   }
  // }

//   Widget paymentContainer({
//     required int no,
//     required String title,
//     required String mainImg,
//     required String option,
//     required int price,
//     required int amount
// }) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CachedNetworkImage( // 동일한 이미지일 경우 캐시에 저장된 이미지를 가져옴
//             imageUrl: mainImg,
//             width: MediaQuery.of(context).size.width * 0.3,
//             fit: BoxFit.cover,
//             placeholder: (context, url) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                   ),
//                 );
//             },
//             errorWidget: (context, url, error){
//                 return const Center(
//                   child: Text("오류 발생"),
//                 );
//             },
//           ),
//           SizedBox(
//             width: 15,
//           ),
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "${title} 외 ${basketList.length} 개",
//                   // textScaleFactor: 1.2,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text("${numberFormat.format(price)}원"),
//                 option_widget(option),
//                 Row(
//                   children: [
//                     const Text('수량'),
//                     Text("$amount"),
//                   ],
//                 ),
//                 Text("합계: ${numberFormat.format(price * amount)}원"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }


  Widget inputTextField({
    required TextEditingController currentController,
    required String currentHintText,
    int? currentMaxLength,
    bool isObscure = false,
    bool isReadOnly = false,
    bool numberOnly = false
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: [
          if(numberOnly)
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
        ],
        readOnly: isReadOnly,
        validator: (value) {
          if (value!.isEmpty) {
            return "내용을 입력해 주세요.";
          }
        },
        controller: currentController,
        maxLength: currentMaxLength,
        obscureText: isObscure,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: currentHintText,
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
              Navigator.push(context, MaterialPageRoute(
                    builder: (context) => KpostalView(
                      callback: (Kpostal result) {
                        try {
                          receiverZipController.text = result.postCode;
                          receiverAddress1Controller.text = result.address;
                        } catch (e){
                          print(e);
                        }
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

  Widget paymentMethodDropdownButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value ?? "";
          });
        },
        underline: Container(),
        isExpanded: true,
        items: paymentMethodList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }


}

