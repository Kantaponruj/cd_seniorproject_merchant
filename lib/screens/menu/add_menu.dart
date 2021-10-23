import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/dropdown.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/component/switch.dart';
import 'package:cs_senior_project_merchant/component/textformfield.dart';
import 'package:cs_senior_project_merchant/models/menu.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/services/menu_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMenuPage extends StatefulWidget {
  AddMenuPage({
    Key key,
    @required this.isUpdating,
    this.categories,
  }) : super(key: key);
  final bool isUpdating;
  final List<String> categories;

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool status = false;
  bool onClickAddOptionalButton = false;
  bool isUpdatingTopping = false;
  int toppingIndex;

  Menu _currentMenu;
  String _imageUrl;
  File _imageFile;

  String _selectedCategory;
  String _selectedType;
  String _selectedNumberTopping;

  List<Topping> _toppingList = [];
  TextEditingController toppingName = new TextEditingController();
  TextEditingController toppingDetail = new TextEditingController();

  List<Map<String, dynamic>> _subtoppingList = [];
  bool statusSubTopping;
  TextEditingController subtoppingName = new TextEditingController();
  TextEditingController subtoppingPrice = new TextEditingController();

  final List<String> type = ['ตัวเลือกเดียว', 'หลายตัวเลือก'];
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

  @override
  void initState() {
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context, listen: false);
    if (widget.isUpdating) {
      _getToppingFromFirebase(menuNotfier);
    }

    if (menuNotfier.currentMenu != null) {
      _currentMenu = menuNotfier.currentMenu;
      _selectedCategory = menuNotfier.currentMenu.categoryFood;
    } else {
      _currentMenu = Menu();
      _selectedCategory = widget.categories.first;
    }
    _selectedType = type.first;
    _selectedNumberTopping = number.first;
    _imageUrl = _currentMenu.image;
    statusSubTopping = false;
    super.initState();
  }

  Future<void> _getToppingFromFirebase(MenuNotfier menu) async {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);

    QuerySnapshot snapshot = await firebaseFirestore
        .collection('stores')
        .doc(store.store.storeId)
        .collection('menu')
        .doc(menu.currentMenu.menuId)
        .collection('topping')
        .get();

    setState(() {
      snapshot.docs.forEach((document) {
        Topping topping = Topping.fromMap(document.data());
        _toppingList.add(topping);
      });
    });

    print(_toppingList);
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

    _currentMenu.categoryFood = _selectedCategory;
    _currentMenu.haveMenu = status;

    updateMenuAndImage(
      _currentMenu,
      _toppingList,
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
    // List<Widget> _addOption =
    //     new List.generate(_count, (int i) => buildAddOption());

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
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _toppingList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          children: [
                            Text(_toppingList[index].type),
                            Text(_toppingList[index].selectedNumberTopping),
                            Text(_toppingList[index].topic),
                            Text(_toppingList[index].detail),
                            Container(
                              child: Column(
                                children: _toppingList[index]
                                    .subTopping
                                    .map(
                                      (subtopping) => Text(
                                          '${subtopping['name']} ${subtopping['price']}'),
                                    )
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _subtoppingList.clear();
                            _selectedType = _toppingList[index].type;
                            _selectedNumberTopping =
                                _toppingList[index].selectedNumberTopping;
                            toppingName.text = _toppingList[index].topic;
                            toppingDetail.text = _toppingList[index].detail;
                            _toppingList[index]
                                .subTopping
                                .forEach((subtopping) {
                              _subtoppingList.add({
                                'name': subtopping['name'],
                                'price': subtopping['price'],
                                'haveSubTopping':
                                    subtopping['haveSubTopping'].toString(),
                              });
                            });
                          });
                          toppingIndex = index;
                          isUpdatingTopping = true;
                          onClickAddOptionalButton = true;
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
                onClickAddOptionalButton
                    ? Container(
                        padding: EdgeInsets.only(top: 20),
                        child: new ListView(
                          children: <Widget>[
                            isUpdatingTopping
                                ? buildAddOption(toppingIndex)
                                : buildAddOption(null),
                          ],
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      )
                    : Container(),
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
                null,
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
                null,
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
                () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return buildAlertDialog();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch() {
    StoreNotifier store = Provider.of<StoreNotifier>(context);

    return SizedBox(
      width: 80,
      child: BuildSwitch(
        width: 100,
        activeText: 'เปิด',
        inactiveText: 'ปิด',
        value: _currentMenu.haveMenu ?? status,
        onToggle: (val) {
          setState(
            () {
              _currentMenu.haveMenu = val;
              updateMenuStatus(store.store.storeId, _currentMenu.menuId, val);
            },
          );
        },
      ),
    );
  }

  Widget buildTextField(String headerText, TextEditingController controller,
      String initialValue, Function onSaved) {
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
            controller: controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String headerText) {
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
            dropdownValues: widget.categories,
            onChanged: (String value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            value: _selectedCategory,
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
              _selectedNumberTopping = value;
            });
          },
          value: _selectedNumberTopping,
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

  // int _count = 1;

  // void _addNewOption() {
  //   setState(() {
  //     _count = _count + 1;
  //   });
  // }

  // void _removeOption() {
  //   setState(() {
  //     _count = _count - 1;
  //   });
  // }

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
          onClickAddOptionalButton
              ? 'ปิดเพิ่มตัวเลือกเพิ่มเติม'
              : 'เพิ่มตัวเลือกเพิ่มเติม',
          () {
            setState(() {
              onClickAddOptionalButton = !onClickAddOptionalButton;
              isUpdatingTopping = false;
            });
          },
        ),
      ],
    );
  }

  Widget buildButton(String text, VoidCallback handleClick) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: handleClick,
      child: Text(
        text,
        style: FontCollection.smallBodyTextStyle,
      ),
    );
  }

  Widget buildAddOption(int index) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    MenuNotfier menuNotfier = Provider.of<MenuNotfier>(context);

    return new BuildPlainCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      'ประเภท',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                  BuildDropdown(
                    dropdownValues: type,
                    onChanged: (String value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    value: _selectedType,
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
                toppingName,
                null,
                (String value) {},
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: buildTextField(
                'รายละเอียด',
                toppingDetail,
                null,
                (String value) {},
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
              child: addList(),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.topLeft,
              child: Text(
                'รายการทั้งหมด',
                style: FontCollection.smallBodyTextStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          _subtoppingList[index]['name'],
                          style: FontCollection.smallBodyTextStyle,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_subtoppingList[index]['price']}   บาท',
                              style: FontCollection.smallBodyTextStyle,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_vert_outlined),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                itemCount: _subtoppingList.length,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: EditButton(
                editText: 'เพิ่มตัวเลือก',
                onClicked: () {
                  setState(() {
                    _subtoppingList.add({
                      'name': subtoppingName.text.trim(),
                      'price': subtoppingPrice.text.trim(),
                      'haveSubTopping': statusSubTopping,
                    });
                  });
                  subtoppingName.clear();
                  subtoppingPrice.clear();
                  print(_subtoppingList);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: EditButton(
                    editText: 'ลบตัวเลือกเพิ่มเติมนี้',
                    onClicked: () {
                      setState(() {
                        deleteTopping(
                          storeNotifier.store.storeId,
                          menuNotfier.currentMenu.menuId,
                          _toppingList[index].toppingId,
                        );
                        _toppingList.removeAt(index);
                        onClickAddOptionalButton = false;
                      });
                      print(_toppingList);
                    },
                  ),
                ),
                Container(
                  child: EditButton(
                    editText: 'เพิ่มตัวเลือกนี้',
                    onClicked: () {
                      List<dynamic> _temporaryList = [];
                      _subtoppingList.forEach((element) {
                        _temporaryList.add({
                          'name': element['name'],
                          'price': element['price'],
                          'haveSubTopping': element['haveSubTopping']
                        });
                      });
                      setState(() {
                        if (isUpdatingTopping) {
                          _toppingList[index] = Topping(
                            toppingId: _toppingList[index].toppingId,
                            type: _selectedType,
                            selectedNumberTopping: _selectedNumberTopping,
                            topic: toppingName.text.trim(),
                            detail: toppingDetail.text.trim(),
                            subTopping: _temporaryList,
                          );
                        } else {
                          _toppingList.add(Topping(
                            type: _selectedType,
                            selectedNumberTopping: _selectedNumberTopping,
                            topic: toppingName.text.trim(),
                            detail: toppingDetail.text.trim(),
                            subTopping: _temporaryList,
                          ));
                        }
                      });
                      print(_toppingList);

                      _selectedType = type.first;
                      _selectedNumberTopping = number.first;
                      toppingName.clear();
                      toppingDetail.clear();
                      _subtoppingList.clear();
                      onClickAddOptionalButton = false;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showList() {
    return Container(
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
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ราคา',
                style: FontCollection.smallBodyTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

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
                textEditingController: subtoppingName,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'โปรดกรอก';
                  }
                  return null;
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: BuildPlainTextField(
              textEditingController: subtoppingPrice,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'โปรดกรอก';
                }
                return null;
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: BuildSwitch(
                width: 80,
                activeText: 'มี',
                inactiveText: 'หมด',
                value: statusSubTopping,
                onToggle: (val) {
                  statusSubTopping = val;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        'หมวดหมู่อาหาร',
        style: FontCollection.bodyTextStyle,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            ListView.builder(
              itemCount: widget.categories.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return catalogLists(widget.categories[index]);
              },
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'เพิ่มหมวดหมู่',
                  style: FontCollection.underlineButtonTextStyle,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: buildButton('บันทึก', () {}),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController test;

  Widget catalogLists(String menu) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 10,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: BuildPlainTextField(
                validator: (value) {},
                initialValue: menu,
                textEditingController: test,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
