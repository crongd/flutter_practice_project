import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/page/user_login_page.dart';
import 'package:flutter_practice_project/page/user_re_password_page.dart';
import 'package:flutter_practice_project/page/user_verification.dart';
import 'package:flutter_practice_project/public/loginCheck.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/UserDTO.dart';
import '../public/constants.dart';

class UserInfoPage extends StatefulWidget {

  UserDTO? user;

  UserInfoPage({
    super.key,
    this.user
  });

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {

  final storage = const FlutterSecureStorage();

  UserDTO? user;

  @override
  void initState() {
    super.initState();
    loginChecking();
    user = widget.user;
    // get_user_info();
  }

  // void get_user_info() async {
  //   // 유저 정보 조회
  //   Response resp = await Dio().get('http://$connectAddr:8080/user_info?userId=${await storage.read(key: 'login')}');
  //   setState(() {
  //     user = UserDTO.fromJson(json: resp.data);
  //   });
  // }

  void loginChecking() async {
    if(!await loginCheck()) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UserLoginPage(no: 0, page: "page"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내 정보 관리", style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('회원 정보', style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 8,
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Container(
                                      width: double.infinity,
                                      child: Text('아이디'),
                                    )
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      width: double.infinity,
                                      child: Text('${user?.id}'),
                                    )
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Container(
                                      width: double.infinity,
                                      child: Text('가입일자'),
                                    )
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      width: double.infinity,
                                      child: Text('${user?.joinDate}'),
                                    )
                                  ),
                                ],
                              ),
                            ],
                          )
                        )
                      ),
                      Flexible(
                        flex: 11,
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Text('휴대전화', textAlign: TextAlign.center,),
                                        )
                                    ),
                                    Flexible(
                                      flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          child: Text('${user?.tel}'),
                                        )
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        width: double.infinity,
                                        child: Text('이메일', textAlign: TextAlign.center,),
                                      )
                                    ),
                                    Flexible(
                                        flex: 2,
                                        child: Container(
                                          width: double.infinity,
                                          child: Text('${user?.email}'),
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            )
                        )
                      )
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      print('비밀번호 변경 화면');
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserVerificationPage())
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('비밀번호 변경', style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                          Icon(Icons.navigate_next),
                        ],
                      )
                    ),
                  ),
                ),
                Container(height: 1, color: Colors.grey,)
            ],
            )


          )
        ],
      ),
    );
  }
}
