import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class AddMenuPage extends StatefulWidget {
  AddMenuPage({Key key, @required this.isUpdating}) : super(key: key);
  final bool isUpdating;

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  bool status = false;
  TextEditingController controller = new TextEditingController();

  Menu _currentMenu;
  String _imageUrl;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'รายละเอียดรายการอาหาร',
      ),
      body: SingleChildScrollView(
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
                child: StadiumButtonWidget(text: 'บันทึก', onClicked: () {}),
              ),
            ],
          ),
        ),
      ),
    );
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
                _currentMenu.haveMenu,
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
                child: Image.network(
                  _imageUrl != null
                      ? _imageUrl
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: buildButton('อัปโหลดรูปภาพใหม่'),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextField(
                  'ชื่อรายการอาหาร', _currentMenu.name, controller),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildTextField(
                  'รายละเอียด', _currentMenu.description, controller),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: buildPrice(_currentMenu.price, controller),
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
    String headerText,
    String hintText,
    TextEditingController controller,
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
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPrice(
    String hintText,
    TextEditingController controller,
  ) {
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
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            'ลบรายการนี้',
            style: FontCollection.underlineButtonTextStyle,
          ),
        ),
        buildButton('เพิ่มตัวเลือกเพิ่มเติม'),
      ],
    );
  }

  Widget buildButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).buttonColor,
      ),
      onPressed: () {},
      child: Text(
        text,
        style: FontCollection.smallBodyTextStyle,
      ),
    );
  }
}
