import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class storeCard extends StatelessWidget {
  storeCard(
      {Key key,
      this.onClicked,
      this.child,
      this.headerText,
      this.canEdit = true})
      : super(key: key);

  final VoidCallback onClicked;
  final String headerText;
  final Widget child;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
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
                canEdit
                    ? Container(
                        alignment: Alignment.bottomRight,
                        child: EditButton(
                          onClicked: onClicked,
                          editText: 'แก้ไข',
                        ),
                      )
                    : SizedBox.shrink(),
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
}
