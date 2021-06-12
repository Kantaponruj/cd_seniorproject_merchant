import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  MainAppbar({Key key, this.appBarTitle})
      : preferredSize = Size.fromHeight(200),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;

  @override
  _MainAppbarState createState() => _MainAppbarState();
}

class _MainAppbarState extends State<MainAppbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          title: Text(widget.appBarTitle),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            )
          ],
          flexibleSpace: SizedBox(
            height: 100,
            child: ButtonWidget(
              text: 'ประวัติการขาย',
              onClicked: () {
              },
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'จัดส่ง',),
              Tab(text: 'รับเอง',),
              Tab(text: 'นัดหมาย',),
            ],
          ),
        ),
      ),
    );
  }
}
