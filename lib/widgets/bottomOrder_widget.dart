import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class BottomOrder extends StatefulWidget {
  const BottomOrder({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  _BottomOrderState createState() => _BottomOrderState();
}

class _BottomOrderState extends State<BottomOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: CollectionsColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: StadiumButtonWidget(
              text: widget.text,
              onClicked: widget.onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
