import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class BottomOrder extends StatefulWidget {
  const BottomOrder({Key key}) : super(key: key);

  @override
  _BottomOrderState createState() => _BottomOrderState();
}

class _BottomOrderState extends State<BottomOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: CollectionsColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: StadiumButtonWidget(
                  text: 'ยืนยันการจัดส่ง', onClicked: () {}),),
          Container(
            margin: EdgeInsets.fromLTRB(0,10,0,0),
            child: Text(
              'ยกเลิกคำสั่งซื้อ',
              style: FontCollection.bodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
