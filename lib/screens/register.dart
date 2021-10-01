import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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

  int currentStep = 0;
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    final isLastStep = currentStep == getSteps(storeNotifier).length - 1;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ลงทะเบียน',
          style: FontCollection.topicBoldTextStyle,
        ),
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        toolbarHeight: 80,
      ),
      key: formKey,
      body: storeNotifier.status == Status.Authenticating
          ? LoadingWidget()
          : Container(
              // padding: EdgeInsets.only(top: 20),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: CollectionsColors.orange,
                  ),
                ),
                child: Stepper(
                  type: StepperType.horizontal,
                  steps: getSteps(storeNotifier),
                  currentStep: currentStep,
                  onStepContinue: () async {
                    if (isLastStep) {
                      setState(() => isCompleted = true);
                      if (!await storeNotifier.signUp()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Register failed")));
                        return;
                      }
                      storeNotifier.clearController();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => BottomBar()),
                          (route) => false);
                      FocusScope.of(context).unfocus();
                    } else {
                      setState(() => currentStep += 1);
                    }
                  },
                  onStepCancel: currentStep == 0
                      ? null
                      : () => setState(() => currentStep -= 1),
                  onStepTapped: (step) => setState(() => currentStep = step),
                  controlsBuilder: (context, {onStepContinue, onStepCancel}) {
                    return Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              text: isLastStep ? 'ลงทะเบียน' : 'ถัดไป',
                              onClicked: onStepContinue,
                            ),
                          ),
                          if (currentStep != 0)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextButton(
                                  child: Text(
                                    'ย้อนกลับ',
                                    style:
                                        FontCollection.underlineButtonTextStyle,
                                  ),
                                  onPressed: onStepCancel,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget buildUsername(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'ชื่อผู้ใช้',
      textEditingController: storeNotifier.displayName,
      hintText: 'กรุณากรอกชื่อผู้ใช้',
      textInputType: TextInputType.text,
      validator: (value) {
        if (value.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLength: 30,
    );
    // onSaved: (value) => setState(() => username = value),
  }

  Widget buildEmail(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'อีเมล',
      textEditingController: storeNotifier.email,
      hintText: 'กรุณากรอกอีเมล',
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
    // onSaved: (value) => setState(() => email = value),
  }

  Widget buildPassword(StoreNotifier storeNotifier) {
    return BuildPasswordField(
      labelText: 'รหัสผ่าน',
      textEditingController: storeNotifier.password,
      hintText: 'กรุณากรอกรหัสผ่าน',
      // textInputType: TextInputType.emailAddress,
      validator: (value) {
        if (value.length < 8) {
          return 'รหัสผ่านห้ามมีความยาวน้อยกว่า 8 ';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildConfirmPassword(StoreNotifier storeNotifier) {
    return BuildPasswordField(
      labelText: 'รหัสผ่านอีกครั้ง',
      textEditingController: storeNotifier.confirmPassword,
      hintText: 'กรุณากยืนยันรหัสผ่าน',
      // textInputType: TextInputType.emailAddress,
      validator: (value) {
        if (value != storeNotifier.password.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildStoreName() {
    return BuildTextField(
      labelText: 'ชื่อร้านค้า',
      // textEditingController: storeNotifier.displayName,
      hintText: 'กรุณากรอกชื่อร้านค้า',
      textInputType: TextInputType.text,
      validator: (value) {
        if (value.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLength: 30,
    );
    // onSaved: (value) => setState(() => username = value),
  }

  Widget buildStoreDes() {
    return BuildTextField(
      labelText: 'คำอธิบายร้านค้า',
      // textEditingController: storeNotifier.displayName,
      hintText: 'กรุณากรอกคำอธิบายร้านค้า',
      textInputType: TextInputType.multiline,
      validator: (value) {
        if (value.length < 4) {
          return 'Enter at least 4 characters';
        } else {
          return null;
        }
      },
      maxLine: null,
    );
    // onSaved: (value) => setState(() => username = value),
  }

  List<Step> getSteps(StoreNotifier storeNotifier) => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('รหัสผู้ใช้งาน'),
          content: Container(
            child: buildForm(
              Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      'ข้อมูลผู้ใช้งาน',
                      style: FontCollection.topicBoldTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: buildUsername(storeNotifier),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: buildEmail(storeNotifier),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: buildPassword(storeNotifier),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: buildConfirmPassword(storeNotifier),
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('ร้านค้า'),
          content: Container(
            child: storePart(),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('เรียบร้อย'),
          content: Container(),
        ),
      ];

  Widget buildForm(Widget child) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(padding: EdgeInsets.all(30), child: child),
    );
  }

  Widget storePart() {
    return Container(
      child: buildForm(
        Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                'ข้อมูลร้านค้า',
                style: FontCollection.topicBoldTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Divider(
                thickness: 2,
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(bottom: 10),
            //   child: buildImage(),
            // ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: buildStoreName(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: buildStoreDes(),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                'รูปแบบการขาย',
                style: FontCollection.bodyBoldTextStyle,
              ),
            ),
            Container(child: saleType('จัดส่ง'),),
            Container(child: saleType('รับเอง'),),
          ],
        ),
      ),
    );
  }

  bool checkbox = false;

  Widget saleType(String text) {
    return Container(
      padding: EdgeInsets.zero,
      child: CheckboxListTile(
        title: Text(text, style: FontCollection.bodyTextStyle,),
        controlAffinity: ListTileControlAffinity.leading,
        value: checkbox,
        onChanged: (bool value) {
        },
        activeColor: CollectionsColors.yellow,
        checkColor: CollectionsColors.white,
      ),
    );
  }
  //
  // File image;
  //
  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if(image == null) return;
  //
  //     final imageTemporary = File(image.path);
  //     setState(() => this.image = imageTemporary);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  // Widget buildImage() {
  //   return InkWell(
  //     onTap: () => pickImage(),
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: 200,
  //       // decoration: BoxDecoration(
  //       //   borderRadius: BorderRadius.circular(20),
  //       //   color: CollectionsColors.yellow,
  //       // ),
  //       // child: Image.file(image, fit: BoxFit.cover,),
  //     ),
  //   );
  // }

}
