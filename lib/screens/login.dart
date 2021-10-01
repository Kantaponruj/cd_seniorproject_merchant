import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
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
          : Center(
              child: SingleChildScrollView(
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
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: buildEmail(storeNotifier),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: buildPassword(storeNotifier),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                  child: Text(
                                    'ลืมรหัสผ่าน',
                                    style:
                                        FontCollection.underlineButtonTextStyle,
                                  ),
                                ),
                                buildSubmit(storeNotifier),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'หากคุณยังไม่มีบัญชี',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => register(context),
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                  child: Text(
                                    'ลงทะเบียน',
                                    style:
                                        FontCollection.underlineButtonTextStyle,
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
            ),
    );
  }

  Widget buildEmail(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'อีเมล',
      textEditingController: storeNotifier.email,
      hintText: 'อีเมล',
      textInputType: TextInputType.emailAddress,
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
    return BuildPasswordField(
      labelText: 'รหัสผ่าน',
      textEditingController: storeNotifier.password,
      hintText: 'รหัสผ่าน',
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
        // final isValid = formKey.currentState.validate();
        if (!await storeNotifier.signIn()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login failed")));
          return;
        }
        storeNotifier.clearController();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
            (route) => false);
        FocusScope.of(context).unfocus();
      },
    );
  }
}
