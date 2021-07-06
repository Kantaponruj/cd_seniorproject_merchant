import 'package:cs_senior_project/component/bottomBar.dart';
import 'package:cs_senior_project/screens/register.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<ScaffoldState>();
  String email = '';
  String password = '';

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
    return Scaffold(
      key: formKey,
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                buildEmail(),
                const SizedBox(
                  height: 30,
                ),
                buildPassword(),
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

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'อีเมล',
        border: OutlineInputBorder(),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      // controller: authNotifier.email,
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
      // controller: authNotifier.password,
      validator: (value) {
        if (value.isEmpty) {
          return 'โปรดระบุรหัสผ่าน';
        }
        return null;
      },
      // onSaved: (value) => setState(() => password = value),
      obscureText: true,
    );
  }

  Widget buildSubmit() {
    return ButtonWidget(
      text: 'เข้าสู่ระบบ',
      onClicked: () async {
        // final isValid = formKey.currentState.validate();
        // if (!await authNotifier.signIn()) {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(const SnackBar(content: Text("Login failed")));
        //   return;
        // }
        // authNotifier.clearController();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => bottomBar()),
            (route) => false);
        FocusScope.of(context).unfocus();
      },
    );
  }
}
