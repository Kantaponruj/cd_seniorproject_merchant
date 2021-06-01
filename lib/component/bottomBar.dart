import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../screens/home.dart';
import '../screens/history.dart';
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
    Home(),
    Notifications(),
    History(),
    Menu(),


  ];
  List<BottomNavigationBarItem> _menuBar
  = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.notifications),
      title: Text('Notification'),
    ),
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.history),
      title: Text('History'),
    ),
    BottomNavigationBarItem(
      icon: Icon(MaterialIcons.menu),
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

