import 'package:flutter/material.dart';

class UserVerificationPage extends StatefulWidget {
  const UserVerificationPage({super.key});

  @override
  State<UserVerificationPage> createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerificationPage> {

  final TextEditingController _pwController = TextEditingController();

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
                TextField(
                    controller: _pwController,
                    decoration: InputDecoration(
                        hintText: "현재 비밀번호"
                    ),
                ),
                TextButton(
                  onPressed: () {

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
