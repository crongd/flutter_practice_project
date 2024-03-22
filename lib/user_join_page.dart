import 'package:flutter/material.dart';


import 'package:dio/dio.dart';
import 'package:flutter_practice_project/models/UserDTO.dart';



class UserJoinPage extends StatefulWidget {
  UserJoinPage({super.key});

  @override
  State<UserJoinPage> createState() => _UserJoinPage();
}

class _UserJoinPage extends State<UserJoinPage> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();

  void join() async {
    String id = idController.text;
    String pw = pwController.text;
    String name = nameController.text;


    Dio().post("http://localhost:8080/user_join",
    options: Options(contentType: Headers.jsonContentType),
    data: UserDTO(id: id, pw: pw, name: name)).toString();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입 페이지"),
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
                  maxLength: 16,
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                  ),
                ),
                TextField(
                  maxLength: 20,
                  controller: pwController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(child: TextButton(onPressed: join, child: Text("가입하기"))),
                  ],
                )
              ],
            )),
      )
    );
  }
}
