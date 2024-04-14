import 'package:flutter/material.dart';
import 'package:flutter_practice_project/page/order_list_page.dart';
import 'package:flutter_practice_project/public/appbar.dart';

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
                      print("내 정보 관리 페이지 이동");
                    },
                    child: Row(
                      children: [
                        Text("jaeho9859", style: TextStyle(fontSize: 16)),
                        Icon(Icons.navigate_next)
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
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text('주문 목록' ,style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.navigate_next),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            GestureDetector(
                onTap: () {
                  print('리뷰 관리 페이지 이동');
                },
                child: Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text('리뷰 관리' ,style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.navigate_next),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      )
                    ],
                  ),
                )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            InkWell(
                onTap: () {
                  print('내 정보 관리 페이지 이동');
                },
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text('내 정보 관리' ,style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.navigate_next),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      )
                    ],
                  ),
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


