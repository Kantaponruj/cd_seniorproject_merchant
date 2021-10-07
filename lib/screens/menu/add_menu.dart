import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
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
    Navigator.pop(context);
  }

  _menuDeleted(Menu menu) {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context, listen: false);
    menuNotfier.deleteMenu(menu);
    Navigator.pop(context);
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: buildSwitch(
                (val) {
                  setState(
                    () {},
                  );
                },
                _currentMenu.haveMenu ?? status,
              ),
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
          ],
        ),
      ),
    );
  }

  Widget buildSwitch(Function handleToggle, bool status) {
    return SizedBox(
      width: 100,
      child: FlutterSwitch(
        width: 100,
        showOnOff: true,
        activeTextColor: CollectionsColors.white,
        activeColor: CollectionsColors.orange,
        inactiveTextColor: CollectionsColors.white,
        activeText: 'เปิด',
        inactiveText: 'ปิด',
        activeTextFontWeight: FontWeight.w400,
        inactiveTextFontWeight: FontWeight.w400,
        value: status,
        onToggle: handleToggle,
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
        buildButton('เพิ่มตัวเลือกเพิ่มเติม', () => {}),
      ],
    );
  }

  Widget buildButton(String text, Function handleClick) {
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
}
