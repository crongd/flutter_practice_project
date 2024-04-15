import 'package:flutter/material.dart';
import 'package:flutter_practice_project/page/user_re_password_page.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
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
                                      child: Text('jaeho1234'),
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
                                      child: Text('2010-01-01'),
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
                                          child: Text('010-1234-1234'),
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
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
                                          child: Text('jaeho1234@naver.com'),
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
                        MaterialPageRoute(builder: (context) => UserRePasswordPage())
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
