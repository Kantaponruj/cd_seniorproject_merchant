import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/component/mainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:bottom_indicator_bar_fork/bottom_indicator_bar_fork.dart';

import '../screens/store.dart';
import '../screens/menu.dart';

class MainBottombar extends StatefulWidget {
  MainBottombar({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<MainBottombar> {
  int _selectedIndex = 1;

  List<Widget> _pageWidget = <Widget>[
    StorePage(),
    MainAppbar(),
    MenuPage(),
  ];

  List<BottomIndicatorNavigationBarItem> items =
      <BottomIndicatorNavigationBarItem>[
    BottomIndicatorNavigationBarItem(
      icon: Icon(
        Icons.store_outlined,
      ),
      label: 'ร้านค้า',
    ),
    BottomIndicatorNavigationBarItem(
      icon: Icon(
        Icons.list_alt_outlined,
      ),
      label: 'คำสั่งซื้อ',
    ),
    BottomIndicatorNavigationBarItem(
      icon: Icon(
        Icons.restaurant_menu_outlined,
      ),
      label: 'รายการอาหาร',
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

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          StorePage(),
          MainAppbar(),
          MenuPage(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
