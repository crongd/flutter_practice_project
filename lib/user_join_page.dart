import 'package:flutter/material.dart';


import 'package:dio/dio.dart';
import 'package:flutter_practice_project/models/UserDTO.dart';
import 'package:flutter_practice_project/user_login_page.dart';



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


    Dio().post("http://192.168.2.3:8080/user_join",
    options: Options(contentType: Headers.jsonContentType),
    data: UserDTO(id: id, pw: pw, name: name)).toString();

    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserLoginPage(no: 0, page: "list"))
    );
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
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', height: 200, width: 300,),
                TextField(
                  maxLength: 16,
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                  ),
                ),
                TextField(
                  obscureText: true,
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
                    Expanded(child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: join,
                      child: Text("가입하기",style: TextStyle(color: Colors.white),))),
                  ],
                )
              ],
            )),
      )
    );
  }
}
