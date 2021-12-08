import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/screens/allDes_map.dart';
import 'package:cs_senior_project_merchant/screens/order.dart';
import 'package:cs_senior_project_merchant/screens/order/notification.dart';
import 'package:cs_senior_project_merchant/screens/store.dart';
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
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: CollectionsColors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
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
            // IconButton(
            //   onPressed: () {
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //         builder: (context) => StorePage()));
            //   },
            //   icon: Icon(
            //     Icons.history,
            //     color: Colors.black,
            //   ),
            // ),
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
              Tab(text: 'จัดส่ง'),
              Tab(text: 'รับเอง'),
              Tab(text: 'นัดหมาย'),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            OrderPage(typeOrder: 'delivery-orders'),
            OrderPage(typeOrder: 'pickup-orders'),
            OrderPage(typeOrder: 'meeting-orders'),
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
