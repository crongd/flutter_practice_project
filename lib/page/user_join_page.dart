import 'package:flutter/material.dart';


import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice_project/page/port_one_certification_page.dart';
import 'package:flutter_practice_project/public/alert.dart';
import 'package:flutter_practice_project/public/constants.dart';
import 'package:flutter_practice_project/models/UserDTO.dart';
import 'package:flutter_practice_project/page/user_login_page.dart';



class UserJoinPage extends StatefulWidget {
  UserJoinPage({super.key});

  @override
  State<UserJoinPage> createState() => _UserJoinPage();
}

class _UserJoinPage extends State<UserJoinPage> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final emailController = TextEditingController();
  final telController = TextEditingController();

  void join() async {
    String id = idController.text;
    String pw = pwController.text;
    String email = emailController.text;
    String tel = telController.text;


    if(id != "" && pw != "" && email != "" && tel != "") {
      Dio().post("http://$connectAddr:8080/user_join",
          options: Options(contentType: Headers.jsonContentType),
          data: UserDTO(id: id, password: pw, email: email, tel: tel)).toString();

      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UserLoginPage(no: 0, page: "list"))
      );
    } else {
      alert(context, "필수 정보가 입력되지 않음.");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        title: Text("회원가입", style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
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
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: '이메일',
                    ),
                  ),
                  TextField(
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly],
                    controller: telController,
                    decoration: InputDecoration(
                      labelText: '전화번호',
                    ),
                  ),
                  TextButton(onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PortOneCertificationPage())
                    );
                  }, child: Text('인증')),
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
        ),
      )
    );
  }
}
