import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/models/UserDTO.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../public/alert.dart';
import '../public/constants.dart';

class UserRePasswordPage extends StatefulWidget {
  const UserRePasswordPage({super.key});

  @override
  State<UserRePasswordPage> createState() => _UserRePasswordPageState();
}

class _UserRePasswordPageState extends State<UserRePasswordPage> {

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

  final storage = const FlutterSecureStorage();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _valPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
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
                      hintText: "변경할 비밀번호"
                  ),
                ),
                TextField(
                  obscureText: true,
                  controller: _valPwController,
                  decoration: InputDecoration(
                      hintText: "비밀번호 확인"
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (_pwController.text == _valPwController.text) {
                      UserDTO user = UserDTO(
                        id: userId,
                        password: _pwController.text
                      );

                      await Dio().patch("http://$connectAddr:8080/user_password", data: user.toJson());
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      alert(context, "비밀번호가 같지 않습니다.");
                    }
                  },
                  child: Text('변경'),
                )
              ],
            ),
          )
      )
    );
  }
}
