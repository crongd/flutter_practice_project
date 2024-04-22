import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/models/OrderDTO.dart';
import 'package:flutter_practice_project/models/UserDTO.dart';
import 'package:flutter_practice_project/page/payment_result_page.dart';
import 'package:flutter_practice_project/public/constants.dart';

/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';

import '../models/ProductDTO.dart';

class PortOnePaymentPage extends StatelessWidget {
  String title; // 결제 제목
  // String merchantUid;
  int amount; // 총 결제 가격
  String buyerName;
  String buyerTel;
  String buyerAddr;
  String buyerPostcode;
  List<ProductDTO> products;
  String userId;



  PortOnePaymentPage({
    super.key,
    required this.title,
    // required this.merchantUid,
    required this.amount,
    required this.buyerName,
    required this.buyerTel,
    required this.buyerAddr,
    required this.buyerPostcode,
    required this.products,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: new AppBar(
        title: new Text('결제', style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
        centerTitle: true,
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg'),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp07007375',
      /* [필수입력] 결제 데이터 */
      data: PaymentData(
          pg: 'html5_inicis',                                            // PG사
          payMethod: 'card',                                             // 결제수단
          name: title,                                                   // 주문명
          merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',   // 주문번호
          amount: amount,                                                // 결제금액
          buyerName: buyerName,                                          // 구매자 이름
          buyerTel: buyerTel,                                            // 구매자 연락처
          // buyerEmail: 'example@naver.com',                            // 구매자 이메일
          buyerAddr: buyerAddr,                                          // 구매자 주소
          buyerPostcode: buyerPostcode,                                  // 구매자 우편번호
          appScheme: 'myPayment',                                        // 앱 URL scheme
          cardQuota : [2,3]                                              //결제창 UI 내 할부개월수 제한
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        print(result);
        // if(result['imp_success'] == true) {
        //   print('결제 요청 ㅇㅋ');
        // } else {
        //   print('결제요청 error' + result['error_msg']!.split('|')[1]);
        // }
        // Dio().post(path)
        if(result['imp_success'] != true) {
          OrderDTO orderDTO =
          OrderDTO(
            impUid: result['imp_uid'],
            user: UserDTO(id: userId),
            products: products,
            name: title,
            buyerAddr: buyerAddr,
            buyerPostcode: buyerPostcode,
            amount: amount,
            payMethod: 'card',
            pgId: 'html5_inicis'
          );

          Dio().post('http://$connectAddr:8080/add_order', data: orderDTO.toJson());
        }


        
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PaymentResultPage(result: result))
        );
      },
    );
  }
}