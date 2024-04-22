import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/page/join_result_page.dart';
import 'package:flutter_practice_project/public/constants.dart';

/* 아임포트 휴대폰 본인인증 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_certification.dart';
/* 아임포트 휴대폰 본인인증 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/certification_data.dart';

import '../models/UserDTO.dart';

class PortOneCertificationPage extends StatelessWidget {
  UserDTO user;

  PortOneCertificationPage({
    super.key,
    required this.user
  });


  @override
  Widget build(BuildContext context) {
    return IamportCertification(
      appBar: new AppBar(
        title: new Text('본인인증', style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
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
      /* [필수입력] 본인인증 데이터 */
      data: CertificationData(
        pg: 'inicis_unified',                                         // PG사
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',  // 주문번호
        mRedirectUrl: 'https://www.google.com',                          // 본인인증 후 이동할 URL
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) async {
        print(result);
        // 본인인증 성공
        if(result['success'] == 'true') {
          print('success 들어옴');
          Response resp = await Dio().post('http://$connectAddr:8080/user_join/${result['imp_uid']}', data: user.toJson());
          bool joinResult = resp.data;
          // Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JoinResultPage(result: result, certification: joinResult))
          );
        } else { // 본인인증 실패
          print('failed 들어옴');
          // Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => JoinResultPage(result: result, certification: false))
          );
        }

      },
    );
  }
}