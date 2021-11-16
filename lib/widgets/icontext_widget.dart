import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:flutter/material.dart';

class BuildIconText extends StatelessWidget {
  BuildIconText({Key key, this.icon, this.text, this.child}) : super(key: key);

  final IconData icon;
  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          icon != null
              ? Container(
                  child: Icon(icon),
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: child == null
                ? Text(
                    text,
                    style: FontCollection.bodyTextStyle,
                    textAlign: TextAlign.right,
                  )
                : child,
          ),
        ],
      ),
    );
  }
}
