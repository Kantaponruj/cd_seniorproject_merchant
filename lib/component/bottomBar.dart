import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/screens/order.dart';
import 'package:flutter/material.dart';
import 'package:bottom_indicator_bar_fork/bottom_indicator_bar_fork.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../screens/order.dart';
import '../screens/store.dart';
import '../screens/menu.dart';
import '../screens/order/notification.dart';

class BottomBar extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<BottomBar> {
  int _selectedIndex = 1;
  List<Widget> _pageWidget = <Widget>[
    StorePage(),
    OrderPage(),
    MenuPage(),
  ];

  List<BottomIndicatorNavigationBarItem> items =
      <BottomIndicatorNavigationBarItem>[
    BottomIndicatorNavigationBarItem(
      icon: Icon(
        Icons.store_outlined,
        color: CollectionsColors.orange,
      ),
      label: 'ร้านค้า',
    ),
    BottomIndicatorNavigationBarItem(
      icon: Icon(
        Icons.list_alt_outlined,
        color: CollectionsColors.orange,
      ),
      label: 'คำสั่งซื้อ',
    ),
    BottomIndicatorNavigationBarItem(
      icon: Icon(
        Icons.restaurant_menu_outlined,
        color: CollectionsColors.orange,
      ),
      label: 'รายการอาหาร',
    ),
  ];

  // List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.store_outlined,
  //     ),
  //     title: Text(
  //       'ร้านค้า',
  //       style: TextStyle(
  //         fontFamily: NotoSansFont,
  //         fontWeight: FontWeight.w400,
  //         fontSize: smallestSize,
  //       ),
  //     ),
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.list_alt_outlined,
  //     ),
  //     title: Text(
  //       'คำสั่งซื้อ',
  //       style: TextStyle(
  //         fontFamily: NotoSansFont,
  //         fontWeight: FontWeight.w400,
  //         fontSize: smallestSize,
  //       ),
  //     ),
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.restaurant_menu_outlined,
  //     ),
  //     title: Text(
  //       'รายการอาหาร',
  //       style: TextStyle(
  //         fontFamily: NotoSansFont,
  //         fontWeight: FontWeight.w400,
  //         fontSize: smallestSize,
  //       ),
  //     ),
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: _menuBar,
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: CollectionsColors.orange,
      //   unselectedItemColor: Colors.grey,
      //   backgroundColor: Colors.white,
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: BottomIndicatorBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: items,
        activeColor: CollectionsColors.orange,
        inactiveColor: Colors.grey,
        indicatorColor: CollectionsColors.orange,
      ),
    );
  }
}
