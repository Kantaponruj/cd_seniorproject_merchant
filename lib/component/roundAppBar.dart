import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/main.dart';
import 'package:cs_senior_project_merchant/screens/order.dart';
import 'package:flutter/material.dart';

class RoundedAppBar extends StatefulWidget implements PreferredSizeWidget {
  RoundedAppBar({Key key,this.appBarTittle})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  final Size preferredSize;
  final String appBarTittle;
  // final String appBarSubTittle;


  @override
  _RoundedAppBarState createState() => _RoundedAppBarState();
}

class _RoundedAppBarState extends State<RoundedAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios_outlined, color: CollectionsColors.white),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          title: Text(widget.appBarTittle, style: FontCollection.topicBoldTextStyle,),
          toolbarHeight: 100,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF2954E), Color(0xFFFAD161)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
          ),
          elevation: 10,
          titleSpacing: 20,
        )
    );
  }elseif(){

  }
  // {
  //   return
  // }
}
