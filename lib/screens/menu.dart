import 'dart:async';

import 'package:cs_senior_project/models/store.dart';
import 'package:cs_senior_project/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Menu extends StatefulWidget {
  static const routeName = '/menu';

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Widget> _children;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        toolbarHeight: 90,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            // gradient: LinearGradient(
            //   begin: Alignment.centerLeft,
            //   end: Alignment.centerRight,
            //   colors: <Color>[Color(0xFFF2954E), Color(0xFFFAD161)],
            // ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is menu page'),
            SearchWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  Widget buildStore(Store store) => ListTile(
        // leading: Image.network(
        //   store != null
        //       ? store.image
        //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
        //   width: 100,
        //   fit: BoxFit.cover,
        // ),
        title: Text(
          store.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          store.name,
        ),
      );
}
