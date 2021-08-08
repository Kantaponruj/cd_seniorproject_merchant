import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Widget child;
  final String headerText;

  const OrderCard({
    Key key,
    this.headerText,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Text(
              headerText,
              style: FontCollection.orderDetailHeaderTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
