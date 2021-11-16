import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/screens/allDes_map.dart';
import 'package:cs_senior_project_merchant/screens/order.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  MainAppbar({
    Key key,
    this.appBarTitle,
    this.map,
    this.history,
  })  : preferredSize = Size.fromHeight(150),
        super(key: key);

  final Size preferredSize;
  final String appBarTitle;
  final VoidCallback map;
  final VoidCallback history;

  @override
  _MainAppbarState createState() => _MainAppbarState();
}

class _MainAppbarState extends State<MainAppbar>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    // TODO: implement
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          backgroundColor: CollectionsColors.white,
          elevation: 0,
          title: titleText(),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllDestinationPage()));
              },
              icon: Icon(
                Icons.map_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: widget.history,
              icon: Icon(
                Icons.history,
                color: Colors.black,
              ),
            ),
          ],
          // flexibleSpace: Container(
          //   height: 400,
          //         alignment: Alignment.bottomCenter,
          //         child: SizedBox(
          //           // height: 350,
          //           child: ButtonWidget(
          //             text: 'ประวัติการขาย',
          //             onClicked: () {},
          //           ),
          //         ),
          // ),
          bottom: TabBar(
            indicatorColor: CollectionsColors.orange,
            indicatorWeight: 3,
            labelColor: Colors.black,
            labelStyle: FontCollection.bodyTextStyle,
            tabs: [
              Tab(
                text: 'จัดส่ง',
              ),
              Tab(
                text: 'รับเอง',
              ),
              Tab(
                text: 'นัดหมาย',
              ),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            OrderPage(),
            OrderPage(),
            OrderPage(),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        'คำสั่งซื้อ',
        style: FontCollection.topicBoldTextStyle,
      ),
    );
  }
}
