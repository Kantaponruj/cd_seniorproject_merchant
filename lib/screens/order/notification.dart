import 'package:flutter/material.dart';


class Store extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _StoreState createState() => _StoreState();
}


class _StoreState extends State<Store> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
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
            Text('This is notification page'),
          ],
        ),
      ),
    );
  }
}
