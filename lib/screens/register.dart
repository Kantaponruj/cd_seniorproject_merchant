import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ScaffoldState>();

    void login(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return LoginPage();
          },
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          key: formKey,
          body: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text('Register'),
                    SizedBox(
                      height: 20,
                    ),
                    buildUsername(),
                    const SizedBox(
                      height: 30,
                    ),
                    buildEmail(),
                    const SizedBox(
                      height: 30,
                    ),
                    buildPassword(),
                    const SizedBox(
                      height: 30,
                    ),
                    buildConfirmPassword(),
                    const SizedBox(
                      height: 30,
                    ),
                    buildSubmit(),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Text(
                        'ลืมรหัสผ่าน',
                        style: TextStyle(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => login(context),
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildUsername() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อผู้ใช้',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLength: 30,
      // onSaved: (value) => setState(() => username = value),
    );
  }

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'อีเมล',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$)';
        final regExp = RegExp(pattern);

        if (value.isEmpty) {
          return 'กรุณากรอกอีเมล';
        } else if (!regExp.hasMatch(value)) {
          return 'กรุณากรอกอีเมลให้ถูกต้อง';
        } else {
          return null;
        }
      },
      // onSaved: (value) => setState(() => email = value),
    );
  }

  Widget buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'รหัสผ่าน',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      validator: (value) {
        if (value.length < 8) {
          return 'รหัสผ่านห้ามมีความยาวน้อยกว่า 8 ';
        } else {
          return null;
        }
      },
      // onSaved: (value) => setState(() => password = value),
      obscureText: true,
    );
  }

  Widget buildConfirmPassword() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ยืนยันรหัสผ่าน',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      validator: (value) {},
      obscureText: true,
    );
  }

  Widget buildSubmit() {
    return ButtonWidget(
      text: 'ลงทะเบียน',
      onClicked: () async {},
    );
  }
}
