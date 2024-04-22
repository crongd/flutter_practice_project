import 'package:flutter/material.dart';

/* 아임포트 휴대폰 본인인증 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_certification.dart';
/* 아임포트 휴대폰 본인인증 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/certification_data.dart';

class PortOneCertificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IamportCertification(
      appBar: new AppBar(
        title: new Text('아임포트 본인인증'),
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
      /* [필수입력] 본인인증 데이터 */
      data: CertificationData(
        pg: 'inicis_unified',                                         // PG사
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',  // 주문번호
        mRedirectUrl: 'https://www.google.com',                          // 본인인증 후 이동할 URL
        name: '이재호',
        phone: '01012341234'
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        print(result);
      },
    );
  }
}