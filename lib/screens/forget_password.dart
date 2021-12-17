import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/login.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                errorStyle: TextStyle(color: Colors.red),
              ),
              controller: storeNotifier.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final pattern =
                    r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]+$)';
                final regExp = RegExp(pattern);

                if (value.isEmpty) {
                  return 'กรุณากรอกอีเมล';
                } else if (!regExp.hasMatch(value)) {
                  return 'กรุณากรอกอีเมลให้ถูกต้อง';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              text: 'ตั้งรหัสผ่านใหม่',
              // width: 150,
              onClicked: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("โปรดตรวจสอบกล่องจดหมายในอีเมลของท่าน")));
                storeNotifier.resetPassword();
                storeNotifier.clearController();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
