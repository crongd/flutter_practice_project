import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice_project/public/constants.dart';
import 'package:flutter_practice_project/page/item_details_page.dart';
import 'package:flutter_practice_project/page/item_list_page.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_practice_project/page/user_join_page.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';



class UserLoginPage extends StatefulWidget {
  int no;
  String page;

  UserLoginPage({super.key,
    required this.no,
    required this.page
  });

  @override
  State<UserLoginPage> createState() => _UserLoginPage();
}



class _UserLoginPage extends State<UserLoginPage> {

  final idController = TextEditingController();
  final pwController = TextEditingController();

  final storage = const FlutterSecureStorage();

  void login() async {
    String id = idController.text;
    String pw = pwController.text;

    var formData = {
      "id" : id,
      "password" : pw
    };

    Response response = await Dio().post("http://$connectAddr:8080/user_login",
        options: Options(contentType: Headers.jsonContentType),
        data: jsonEncode(formData));
    // print(response.data);

    if(response.data) {
      print('로그인 성공');

      await storage.write(key: "login", value: id);
      // Navigator.of(context).pop();
      Navigator.of(context).pop();

      // if(widget.page == "list") {
      //   // Navigator.of(context).pop();
      //   Navigator.of(context).push(
      //       MaterialPageRoute(builder: (context) => ItemListPage(no: widget.no))
      //   );
      // } else if(widget.page == "") {
      //   // Navigator.of(context).pop();
      //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetailsPage(no: widget.no)));
      // }

    } else {
      alert(context, "입력한 정보가 일치하지 않음");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        title: Text("로그인", style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.jpg', height: 300, width: 300,),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    controller: pwController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: login,
                          child: Text(
                            "로그인",
                            style: TextStyle(color: Colors.white),
                          )
                      )
                      ),
                      SizedBox(width: 10,),
                      Expanded(child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => UserJoinPage())
                            );
                          }, child: Text(
                        "회원가입",
                        style: TextStyle(color: Colors.white),)
                      )
                      ),
                    ],
                  ),
                  getKakaoLoginButton()
                ],
              )),
        ),
      )
    );
  }

  void signInWithKakao() async {
    // 카카오 로그인 구현 예제

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
  }

  Widget getKakaoLoginButton() {
    return InkWell(
      onTap: () {
        signInWithKakao();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 2,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Image.asset('assets/images/login/kakaoLogin.png'),
        ),
      ),
    );
  }




}
