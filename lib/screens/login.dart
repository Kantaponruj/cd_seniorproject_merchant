import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/register.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<ScaffoldState>();

  void register(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return RegisterPage();
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
                        height: 150,
                      ),
                      buildEmail(storeNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      buildPassword(storeNotifier),
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
                        onTap: () => register(context),
                        child: Text(
                          'ลงทะเบียน',
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
        if (value.isEmpty) {
          return 'โปรดระบุรหัสผ่าน';
        }
        return null;
      },
      obscureText: true,
    );
  }

  Widget buildSubmit(StoreNotifier storeNotifier) {
    return ButtonWidget(
      text: 'เข้าสู่ระบบ',
      onClicked: () async {
        // final isValid = formKey.currentState.validate();
        if (!await storeNotifier.signIn()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login failed")));
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
