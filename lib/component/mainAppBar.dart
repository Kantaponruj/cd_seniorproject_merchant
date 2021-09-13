import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  MainAppbar({Key key, this.appBarTitle})
      : preferredSize = Size.fromHeight(150),
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
          backgroundColor: CollectionsColors.white,
          elevation: 0,
          title: titleText(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
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
          ),
        ),
      ),
    );
  }

  Widget titleText() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        widget.appBarTitle,
        style: FontCollection.topicBoldTextStyle,
      ),
    );
  }
}
