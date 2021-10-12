import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/dropdown.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/component/switch.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/menu.dart';
import 'package:cs_senior_project_merchant/services/menu_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMenuPage extends StatefulWidget {
  AddMenuPage({Key key, @required this.isUpdating}) : super(key: key);
  final bool isUpdating;

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool status = false;
  TextEditingController controller = new TextEditingController();

  Menu _currentMenu;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context, listen: false);
    if (menuNotfier.currentMenu != null) {
      _currentMenu = menuNotfier.currentMenu;
    } else {
      _currentMenu = Menu();
    }
    _imageUrl = _currentMenu.image;
    super.initState();
  }

  _menuUploaded(Menu menu) {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context, listen: false);
    if (!widget.isUpdating) {
      menuNotfier.addMenu(menu);
    }
    Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
  }

  _menuDeleted(Menu menu) {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context, listen: false);
    menuNotfier.deleteMenu(menu);
    Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
  }

  handleSaveMenu() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);

    _formKey.currentState.save();

    _currentMenu.categoryFood = 'test';
    _currentMenu.haveMenu = false;

    updateMenuAndImage(
      _currentMenu,
      widget.isUpdating,
      _imageFile,
      _menuUploaded,
      storeNotifier.store.storeId,
    );
  }

  getLocalImage() async {
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
    List<Widget> _addOption =
        new List.generate(_count, (int i) => buildAddOption());

    List<Widget> _addNewLists =
        new List.generate(_count2, (int i) => addList());

    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'รายละเอียดรายการอาหาร',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                mainCard(),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: new ListView(
                    children: _addOption,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: cardOption(),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: StadiumButtonWidget(
                    text: 'บันทึก',
                    onClicked: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      handleSaveMenu();
                    },
                  ),
                ),
              ],
            ),
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

  Widget mainCard() {
    return BuildPlainCard(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: buildSwitch(),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'รูปภาพอาหาร',
                style: FontCollection.bodyTextStyle,
              ),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                child: showImage(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: buildButton('อัปโหลดรูปภาพใหม่', getLocalImage),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextField(
                'ชื่อรายการอาหาร',
                _currentMenu.name,
                (String value) {
                  _currentMenu.name = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextField(
                'รายละเอียด',
                _currentMenu.description,
                (String value) {
                  _currentMenu.description = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildPrice(
                _currentMenu.price,
                (String value) {
                  _currentMenu.price = value;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildDropdown(
                'หมวดหมู่',
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildButton(
                'แก้ไขหมวดหมู่',
                () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch() {
    return SizedBox(
      width: 80,
      child: BuildSwitch(
        width: 100,
        activeText: 'เปิด',
        inactiveText: 'ปิด',
        value: _currentMenu.haveMenu ?? status,
        onToggle: (val) {
          setState(
            () {},
          );
        },
      ),
    );
  }

  Widget buildTextField(
      String headerText, String initialValue, Function onSaved,
      {String hintText}) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              headerText,
              style: FontCollection.bodyTextStyle,
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(
    String headerText,
  ) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              headerText,
              style: FontCollection.bodyTextStyle,
            ),
          ),
          BuildDropdown(
            width: MediaQuery.of(context).size.width,
            dropdownValues: catalog,
            hintText: 'กรุณาเลือกหมวดหมู่',
            onChanged: (String value) {
              setState(() {
                _chosenValue = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildPrice(String initialValue, Function onSaved, {String hintText}) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(right: 20),
          child: Text(
            'ราคา',
            style: FontCollection.bodyTextStyle,
          ),
        ),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onSaved: onSaved,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'บาท',
            style: FontCollection.bodyTextStyle,
          ),
        ),
      ],
    );
  }

  Widget buildRowDropdown() {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(right: 20),
          child: Text(
            'เลือกได้สูงสุด',
            style: FontCollection.bodyTextStyle,
          ),
        ),
        Container(
            child: BuildDropdown(
          dropdownValues: number,
          hintText: 'จำนวน',
          onChanged: (String value) {
            setState(() {
              _chosenValue = value;
            });
          },
        )),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'ตัวเลือก',
            style: FontCollection.bodyTextStyle,
          ),
        ),
      ],
    );
  }

  int _count = 1;

  void _addNewOption() {
    setState(() {
      _count = _count + 1;
    });
  }

  void _removeOption() {
    setState(() {
      _count = _count - 1;
    });
  }

  Widget cardOption() {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => deleteMenu(
            _currentMenu,
            _menuDeleted,
            storeNotifier.store.storeId,
          ),
          child: Text(
            'ลบรายการนี้',
            style: FontCollection.underlineButtonTextStyle,
          ),
        ),
        buildButton(
          'เพิ่มตัวเลือกเพิ่มเติม',
          () {
            _addNewOption();
          },
        ),
      ],
    );
  }

  Widget buildButton(String text, VoidCallback handleClick) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).buttonColor,
      ),
      onPressed: handleClick,
      child: Text(
        text,
        style: FontCollection.smallBodyTextStyle,
      ),
    );
  }

  int _count2 = 1;

  void _addNewList() {
    setState(() {
      _count2 = _count2 + 1;
    });
  }

  void _removeList() {
    setState(() {
      _count2 = _count2 - 1;
    });
  }

  Widget buildAddOption() {
    List<Widget> _addNewLists =
        new List.generate(_count2, (int i) => addList());

    return new BuildPlainCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  BuildDropdown(
                    dropdownValues: type,
                    hintText: 'กรุณาเลือกประเภท',
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: buildRowDropdown(),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: buildTextField(
                'ชื่อตัวเลือก',
                ' ',
                (String value) {
                  _currentMenu.name = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: buildTextField(
                'รายละเอียด',
                ' ',
                (String value) {
                  _currentMenu.name = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      'รายการเพิ่มเติม',
                      style: FontCollection.smallBodyTextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ราคาเพิ่ม',
                        style: FontCollection.smallBodyTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: new ListView(
                children: _addNewLists,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: EditButton(
                editText: 'เพิ่มตัวเลือก',
                onClicked: () {
                  _addNewList();
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: EditButton(
                editText: 'ลบตัวเลือกเพิ่มเติมนี้',
                onClicked: () {
                  _removeOption();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _chosenValue;

  final List<String> type = ['ตัวเลือกเดียว', 'หลายตัวเลือก'];
  final List<String> catalog = [
    'โตเกียว',
    'โตเกียวยักษ์',
    'อื่น ๆ',
  ];
  final List<String> number = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  bool testSwitch = false;

  Widget addList() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: BuildPlainTextField(
                initialValue: '',
                validator: (String value) {
                  _currentMenu.name = value;
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: BuildPlainTextField(
              initialValue: '',
              validator: (String value) {
                _currentMenu.name = value;
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: BuildSwitch(
                width: 80,
                activeText: 'มี',
                inactiveText: 'หมด',
                value: testSwitch,
                onToggle: (val) {
                  setState() {}
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                _removeList();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
