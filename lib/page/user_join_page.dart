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

  bool idCheck = false;
  String idCheckTitle = '';

  void join() async {
    String id = idController.text;
    String pw = pwController.text;
    String email = emailController.text;
    String tel = telController.text;


    if(id != "" && pw != "" && email != "" && tel != "" && idCheck) {

      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PortOneCertificationPage(user: UserDTO(id: id, password: pw, email: email, tel: tel),))
      );
    } else {
      alert(context, "필수 정보가 입력되지 않았거나, 아이디 중복체크가 되지 않았습니다.");
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
                  Row(
                    children: [
                      Flexible(
                        flex: 7,
                        child: TextField(
                          maxLength: 16,
                          controller: idController,
                          decoration: InputDecoration(
                            labelText: '아이디',
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                          child: TextButton(
                            onPressed: () async {
                              String id = idController.text;
                              print(id);
                              Response check = await Dio().get('http://$connectAddr:8080/user_id_duplication_check?id=$id');
                              setState(() {
                               idCheck = true;

                               !check.data ? idCheckTitle = '사용 가능한 아이디 입니다.' : idCheckTitle = '중복된 아이디 입니다.';
                              });
                            },
                            child: Text(
                                "중복확인",
                                style: TextStyle(fontSize: 15, color: Colors.black), overflow: TextOverflow.fade,textAlign: TextAlign.center,),)
                      )
                    ],
                  ),
                  if(idCheck) Text(idCheckTitle),
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
                          child: Text("본인인증 후 가입하기",style: TextStyle(color: Colors.white),))),
                    ],
                  )
                ],
              )),
        ),
      )
    );
  }
}
