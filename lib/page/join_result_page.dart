import 'package:flutter/material.dart';
import 'package:flutter_practice_project/page/user_join_page.dart';

class JoinResultPage extends StatelessWidget {
  Map<String, String> result;
  bool certification;

  JoinResultPage({
    super.key,
    required this.result,
    required this.certification
  });

  bool getIscertification(certication) {
    return certification;
  }

  bool getIsSuccessed(Map<String, String> result) {
    if (result['imp_success'] == 'true') {
      return true;
    }
    if (result['success'] == 'true') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, String> result = ModalRoute.of(context).settings.arguments;
    bool isSuccessed = getIsSuccessed(result);

    return Scaffold(
      appBar: new AppBar(
        title: Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isSuccessed && certification ? '회원가입이 성공하였습니다' : '회원가입이 실패하였습니다',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 50.0),
            child: Column(
              children: <Widget>[
                isSuccessed && certification ? Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text('가입을 환영합니다',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,)
                      )
                    ],
                  )
                ) : Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text('에러 ', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(result['error_msg'] ?? "입력한 전화번호 검증 실패"),
                      ),
                    ],
                  ),
                ),
                isSuccessed && certification ?
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: TextButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text("로그인 화면으로"),)
                ) :
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: TextButton(onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserJoinPage())
                    );
                  }, child: Text("회원가입 화면으로"),)
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}