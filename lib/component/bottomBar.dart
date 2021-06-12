import 'package:cs_senior_project/screens/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../screens/order.dart';
import '../screens/store.dart';
import '../screens/menu.dart';
import '../screens/notification.dart';

class bottomBar extends StatefulWidget {
  static const routeName = '/';

  @override
  _State createState() => _State();
}

class _State extends State<bottomBar> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    StorePage(),
    OrderPage(),
    MenuPage(),
  ];

  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(
        Icons.store_outlined,
      ),
      title: Text('Store'),
    ),
    BottomNavigationBarItem(
      icon: Icon(
  Icons.list_alt_outlined,
  ),
      title: Text('Order'),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.restaurant_menu_outlined,
      ),
      title: Text('Menu'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
