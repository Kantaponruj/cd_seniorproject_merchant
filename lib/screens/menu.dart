import 'dart:async';

import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  static const routeName = '/menu';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTittle: 'Menu',
        ),
        body: Center(
          child: Container(
            color: Colors.teal,
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('This is menu page'),
                // SearchWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
