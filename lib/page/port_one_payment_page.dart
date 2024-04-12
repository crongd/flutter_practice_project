

import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class Payment extends StatelessWidget {
  int amount;
  String productName;
  String buyerPostcode;
  String buyerName;
  String buyerTel;
  String buyerAddr;


  Payment({
    super.key,
    required this.amount,
    required this.productName,
    required this.buyerPostcode,
    required this.buyerName,
    required this.buyerTel,
    required this.buyerAddr
  });

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: AppBar(
        title: const Text('아임포트 결제'),
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg'),
              // Image.asset('assets/images/iamport-logo.png'),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
      // [필수입력] 가맹점 식별코드
      userCode: 'iamport',
      data: PaymentData(
          payMethod: 'card',
          name: productName,
          merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
          amount: amount,
          buyerName: buyerName,
          buyerAddr: buyerAddr,
          buyerTel: buyerTel,
          buyerPostcode: buyerPostcode,
          appScheme: 'example'
      ),

      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(context, '/result', arguments: result);
      },
    );
  }
}
