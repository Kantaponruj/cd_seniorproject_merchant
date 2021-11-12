import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<ScaffoldState>();

  String password = '';

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
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Scaffold(
      key: formKey,
      body: storeNotifier.status == Status.Authenticating
          ? LoadingWidget()
          : SingleChildScrollView(
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
                      buildUsername(storeNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildEmail(storeNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildPassword(storeNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildConfirmPassword(storeNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildSubmit(storeNotifier),
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
    );
  }

  Widget buildUsername(StoreNotifier storeNotifier) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อผู้ใช้',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: storeNotifier.displayName,
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

  Widget buildEmail(StoreNotifier storeNotifier) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'อีเมล',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: storeNotifier.email,
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

  Widget buildPassword(StoreNotifier storeNotifier) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'รหัสผ่าน',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: storeNotifier.password,
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

  Widget buildConfirmPassword(StoreNotifier storeNotifier) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ยืนยันรหัสผ่าน',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      controller: storeNotifier.confirmPassword,
      validator: (value) {
        if (value != storeNotifier.password.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => password = value),
      obscureText: true,
    );
  }

  Widget buildSubmit(StoreNotifier storeNotifier) {
    return ButtonWidget(
      text: 'ลงทะเบียน',
      onClicked: () async {
        if (!await storeNotifier.signUp()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Register failed")));
          return;
        }
        storeNotifier.clearController();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainBottombar()),
            (route) => false);
        FocusScope.of(context).unfocus();
      },
    );
  }
}
