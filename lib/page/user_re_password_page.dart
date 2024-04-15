import 'package:flutter/material.dart';

class UserRePasswordPage extends StatefulWidget {
  const UserRePasswordPage({super.key});

  @override
  State<UserRePasswordPage> createState() => _UserRePasswordPageState();
}

class _UserRePasswordPageState extends State<UserRePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
        centerTitle: true,
      ),
      body: Container(child: Text('비밀번호 변경 페이지'),),
    );
  }
}
