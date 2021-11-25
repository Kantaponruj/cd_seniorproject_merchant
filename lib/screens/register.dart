import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/component/checkBox.dart';
import 'package:cs_senior_project_merchant/component/dropdown.dart';
import 'package:cs_senior_project_merchant/component/storeCard.dart';
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
  List<String> typeOfStore = ['Food Truck', 'ร้านค้ารถเข็น'];
  List<String> kindOfFood = ['ของคาว', 'ของหวาน', 'เครื่องดื่ม', 'อื่น ๆ'];
  List<bool> isSelectedKindOfFood = [false, false, false, false];
  String selectedTypeOfStore;
  String password = '';

  int currentStep = 0;
  bool isCompleted = false;

  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);
    store.clearController();
    super.initState();
  }

  void login(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoginPage();
        },
      ),
    );
  }

  void getLocalImage() async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

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
                      storeNotifier.localFile = _imageFile;
                      setState(() => isCompleted = true);
                      if (!await storeNotifier.signUp()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("ลงทะเบียนล้มเหลว โปรดลองอีกครั้ง")));
                        return;
                      }
                      storeNotifier.clearController();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainBottombar()),
                        (route) => false,
                      );
                      FocusScope.of(context).unfocus();
                    } else {
                      setState(() => currentStep += 1);
                    }
                  },
                  onStepCancel: currentStep == 0
                      ? null
                      : () => setState(() => currentStep -= 1),
                  onStepTapped: (step) => setState(() => currentStep = step),
                  controlsBuilder: (context, {onStepCancel, onStepContinue}) {
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

  Widget showImage() {
    if (_imageUrl == null && _imageFile == null) {
      return Image.network(
        'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
        fit: BoxFit.cover,
      );
    } else if (_imageFile != null) {
      return Image.file(_imageFile, fit: BoxFit.cover);
    } else if (_imageUrl != null) {
      return Image.network(_imageUrl, fit: BoxFit.cover);
    }
  }

  Widget buildUsername(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'ชื่อผู้ใช้',
      textEditingController: storeNotifier.displayName,
      hintText: 'กรุณากรอกชื่อผู้ใช้',
      textInputType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'โปรดระบุชือ่ผู้ใช้';
        }

        return null;
      },
      maxLength: 30,
    );
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
      validator: (value) {
        if (value != storeNotifier.password.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => password = value),
    );
  }

  Widget buildStoreName(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'ชื่อร้านค้า',
      textEditingController: storeNotifier.storeName,
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
  }

  Widget buildStoreDes(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'คำอธิบายร้านค้า',
      textEditingController: storeNotifier.description,
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
  }

  Widget buildStorePhone(StoreNotifier storeNotifier) {
    return BuildTextField(
      labelText: 'เบอร์โทรศัพท์',
      textEditingController: storeNotifier.phone,
      hintText: 'กรุณาระบุเบอรืโทรศัพท์',
      textInputType: TextInputType.phone,
      validator: (value) {
        if (value.length != 10 || value[0] != '0') {
          return 'โปรดระบุเบอร์โทรศัพท์ให้ถูกต้อง';
        } else {
          return null;
        }
      },
      maxLine: null,
    );
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
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: CollectionsColors.grey,
                  child: showImage(),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: NoShapeButton(
                      onClicked: () => getLocalImage(),
                      text: 'อัปโหลดรูปภาพใหม่',
                    ),
                  ),
                ),
                storePart(),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('เรียบร้อย'),
          content: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  color: CollectionsColors.grey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    child: showImage(),
                  ),
                ),
                storeCard(
                  headerText: 'ข้อมูลผู้ใช้',
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        showResult('ชื่อผู้ใช้',
                            storeNotifier.displayName.text.trim()),
                        showResult('อีเมล', storeNotifier.email.text.trim()),
                      ],
                    ),
                  ),
                  canEdit: false,
                  onClicked: () {},
                ),
                storeCard(
                  headerText: 'ข้อมูลร้านคัา',
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        showResult('ชื่อ', storeNotifier.storeName.text.trim()),
                        showResult(
                            'คำอธิบาย', storeNotifier.description.text.trim()),
                        showResult(
                            'หมายเลขโทรศัพท์', storeNotifier.phone.text.trim()),
                        showResult('ประเภทร้านค้า', storeNotifier.typeOfStore),
                        showResult(
                          'ประเภทสินค้า',
                          storeNotifier.kindOfFood.join(', '),
                        ),
                      ],
                    ),
                  ),
                  canEdit: false,
                  onClicked: () {},
                ),
              ],
            ),
          ),
        ),
      ];

  Widget buildForm(Widget child) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(padding: EdgeInsets.all(30), child: child),
    );
  }

  Widget storePart() {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

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
            Container(
              margin: EdgeInsets.only(top: 20),
              child: buildStoreName(storeNotifier),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: buildStoreDes(storeNotifier),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: buildStorePhone(storeNotifier),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                'รูปแบบการขาย',
                style: FontCollection.bodyTextStyle,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: buildDropdown(storeNotifier),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 20),
              child: salesType('ประเภทสินค้า', storeNotifier),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(StoreNotifier storeNotifier) {
    return BuildDropdown(
      value: selectedTypeOfStore,
      hintText: 'เลือกรูปแบบการขาย',
      dropdownValues: typeOfStore,
      onChanged: (value) {
        setState(() {
          selectedTypeOfStore = value;
          storeNotifier.typeOfStore = value;
        });
      },
    );
  }

  Widget showResult(String header, String result) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            child: Text(
              header + ': ',
              style: FontCollection.bodyBoldTextStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              result,
              style: FontCollection.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget salesType(String headerText, StoreNotifier storeNotifier) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            headerText,
            style: FontCollection.bodyTextStyle,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: kindOfFood.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BuildCheckBox(
              title: kindOfFood[index],
              value: isSelectedKindOfFood[index],
              onChanged: (value) {
                setState(() {
                  isSelectedKindOfFood[index] = value;
                });

                if (value) {
                  storeNotifier.kindOfFood.add(kindOfFood[index]);
                } else {
                  storeNotifier.kindOfFood.remove(kindOfFood[index]);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
