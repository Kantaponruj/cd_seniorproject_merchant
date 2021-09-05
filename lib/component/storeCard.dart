import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:flutter/material.dart';

Widget storeCard(VoidCallback onClicked, String headerText, Widget child) {
  return Container(
    child: Column(
      children: [
        Container(
          // alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  headerText,
                  style: FontCollection.orderDetailHeaderTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  'แก้ไข',
                  style: FontCollection.bodyTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onClicked,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ),
      ],
    ),
  );
}
