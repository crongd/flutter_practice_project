

import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

class Payment extends StatelessWidget {

  Payment({super.key});

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
          merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
          amount: 30000,
          buyerName: '홍길동',
          buyerTel: '01012345678',
          appScheme: 'example'
      ),

      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(context, '/result', arguments: result);
      },
    );
  }
}
