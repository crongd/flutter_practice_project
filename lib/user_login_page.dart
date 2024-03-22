import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practice_project/item_list_page.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_practice_project/user_join_page.dart';
import 'package:flutter_practice_project/item_list_page.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class UserLoginPage extends StatefulWidget {
  UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPage();
}



class _UserLoginPage extends State<UserLoginPage> {

  final idController = TextEditingController();
  final pwController = TextEditingController();

  final storage = new FlutterSecureStorage();

  void login() async {
    String id = idController.text;
    String pw = pwController.text;

    var formData = {
      "id" : id,
      "pw" : pw
    };

    Response response = await Dio().post("http://localhost:8080/user_login",
        options: Options(contentType: Headers.jsonContentType),
        data: jsonEncode(formData));
    // print(response.data);

    if(response.data) {
      print('로그인 성공');

      await storage.write(key: "login", value: id);
      Navigator.of(context).pop();


      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => ItemListPage(no: 0))
      // );
    } else {
      alert(context, "입력한 정보가 일치하지 않음");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인 페이지"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                  ),
                ),
                TextField(
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
                    Expanded(child: TextButton(onPressed: login, child: Text("로그인"))),
                    Expanded(child: TextButton(onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserJoinPage())
                      );
                    }, child: Text("회원가입"))),
                  ],
                )
              ],
            )),
      )
    );
  }
}
