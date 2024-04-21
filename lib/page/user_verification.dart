import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/page/user_re_password_page.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_practice_project/public/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserVerificationPage extends StatefulWidget {
  const UserVerificationPage({super.key});

  @override
  State<UserVerificationPage> createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerificationPage> {

  final storage = const FlutterSecureStorage();

  final TextEditingController _pwController = TextEditingController();

  String? userId;
  @override
  void initState() {
    super.initState();
    userCheck();

  }

  void userCheck() async {
    String? id = await storage.read(key: 'login');
    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("회원 검증"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('아이디 : ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text('${userId}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  ],
                ),
                TextField(
                  obscureText: true,
                  controller: _pwController,
                  decoration: InputDecoration(
                      hintText: "현재 비밀번호"
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    var formData = {
                      "id" : await storage.read(key: 'login'),
                      "password" : _pwController.text
                    };

                    Response response = await Dio().post("http://$connectAddr:8080/user_login",
                        options: Options(contentType: Headers.jsonContentType),
                        data: jsonEncode(formData));
                    //TODO: 현재 비밀번호로 검증
                    // Response user = await Dio().post('http://$connectAddr:8080/user_login');
                    if(response.data) {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserRePasswordPage())
                      );
                    } else {
                      alert(context, "비밀번호가 일치하지 않음");
                    }

                  },
                  child: Text('확인'),
                )
              ],
            ),
        )
      )
    );
  }
}
