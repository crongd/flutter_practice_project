import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practice_project/public/constants.dart';
import 'package:flutter_practice_project/page/item_details_page.dart';
import 'package:flutter_practice_project/page/item_list_page.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_practice_project/page/user_join_page.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



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
                  )
                ],
              )),
        ),
      )
    );
  }
}
