import 'package:cs_senior_project/main.dart';
import 'package:cs_senior_project/screens/order.dart';
import 'package:flutter/material.dart';

class RoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  RoundedAppBar({Key key,this.appBarTittle})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  final Size preferredSize;
  final String appBarTittle;


  @override
  _RoundedAppBarState createState() => _RoundedAppBarState();
}

class _RoundedAppBarState extends State<RoundedAppBar> {

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.appBarTittle),
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       )),
        // ),
        elevation: 10,
        titleSpacing: 20,
      )
  );
  // {
  //   return
  // }
}
