import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/page/order_list_page.dart';
import 'package:flutter_practice_project/page/review_page.dart';
import 'package:flutter_practice_project/page/user_info_page.dart';
import 'package:flutter_practice_project/page/user_login_page.dart';
import 'package:flutter_practice_project/public/appbar.dart';
import 'package:flutter_practice_project/public/constants.dart';
import 'package:flutter_practice_project/public/loginCheck.dart';
import 'package:flutter_practice_project/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/UserDTO.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "my page",
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final storage = const FlutterSecureStorage();

  // String? userId;
  UserDTO? user;

  @override
  void initState() {
    super.initState();
    loginChecking();
    get_user_info();
    // setState(() async {
    //   userId = await storage.read(key: 'login');
    // });
  }
  
  void get_user_info() async {
    // 유저 정보 조회
    Response resp = await Dio().get('http://$connectAddr:8080/user_info?userId=${await storage.read(key: 'login')}');
    setState(() {
      user = UserDTO.fromJson(json: resp.data);
    });
  }

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
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        title: Text("마이페이지",
          style: TextStyle(
          fontFamily: 'Jalnan',
          // fontWeight: FontWeight.bold
          fontWeight: FontWeight.w500
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserInfoPage(user: user,))
                      );
                    },
                    child: Row(
                      children: [
                        Text("${user?.id}", style: TextStyle(fontSize: 16)),
                        Icon(Icons.navigate_next),
                        IconButton(onPressed: () {
                          storage.delete(key: 'login');
                          MarketPage.changePage(context, 1);
                        }, icon: Icon(Icons.logout))
                      ]
                    ),
                  )
                ],
              )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            GestureDetector(
              onTap: () {
                print('주문목록 페이지 이동');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OrderListPage())
                );
              },
              child: Container(
                color: Colors.white,
                height: 100,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('주문 목록' ,style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                )
              )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            GestureDetector(
                onTap: () {
                  print('리뷰 관리 이동');
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReviewPage())
                  );
                },
                child: Container(
                    color: Colors.white,
                    height: 100,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('리뷰 관리' ,style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                          Icon(Icons.navigate_next),
                        ],
                      ),
                    )
                )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),GestureDetector(
                onTap: () {
                  print('내 정보 관리 페이지 이동');
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserInfoPage(user: user,))
                  );
                },
                child: Container(
                    height: 100,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('내 정보 관리' ,style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                          Icon(Icons.navigate_next),
                        ],
                      ),
                    )
                )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
      )
    );
  }
}


