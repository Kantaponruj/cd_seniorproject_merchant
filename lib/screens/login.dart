import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/forget_password.dart';
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
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: CollectionsColors.orange,
                  ),
                ),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: Image.asset(
                              'assets/images/stalltruckr_merchant_logo.png'),
                        ),
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
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              EditButton(
                                onClicked: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ForgetPasswordPage(),
                                    ),
                                  );
                                },
                                editText: 'ลืมรหัสผ่าน',
                              ),
                              buildSubmit(storeNotifier),
                            ],
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
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  'หากคุณยังไม่มีบัญชี ',
                                  style: FontCollection.bodyTextStyle,
                                ),
                              ),
                              InkWell(
                                onTap: () => register(context),
                                child: Text(
                                  'ลงทะเบียนที่นี่',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
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

  Widget buildEmail(StoreNotifier storeNotifier) {
    return BuildTextField(
      hintText: 'กรุณากรอกอีเมล',
      labelText: 'อีเมล',
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
      textEditingController: storeNotifier.email,
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget buildPassword(StoreNotifier storeNotifier) {
    return BuildPasswordField(
      labelText: 'รหัสผ่าน',
      textEditingController: storeNotifier.password,
      hintText: 'กรุณากรอกรหัสผ่าน',
      validator: (value) {
        if (value.isEmpty) {
          return 'โปรดระบุรหัสผ่าน';
        }
        return null;
      },
    );
  }

  Widget buildSubmit(StoreNotifier storeNotifier) {
    return ButtonWidget(
      text: 'เข้าสู่ระบบ',
      onClicked: () async {
        if (!await storeNotifier.signIn()) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("อีเมลหรือรหัสผ่านไม่ถูกถ้อง")));
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
