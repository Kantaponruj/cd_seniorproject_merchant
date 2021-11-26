import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:flutter/material.dart';

class MenuDetailPage extends StatefulWidget {
  MenuDetailPage({Key key}) : super(key: key);

  @override
  _MenuDetailPageState createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RoundedAppBar(
        appBarTittle: 'รายละเอียดรายการอาหาร',
        action: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: Stack(
            children: [
              Column(
                children: [
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 200,
                  //   child: showImage(),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
