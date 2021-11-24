import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
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

class BuildCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onClicked;
  final String headerText;
  final bool canEdit;
  final String editText;

  BuildCard({
    Key key,
    this.headerText,
    this.onClicked,
    @required this.child,
    @required this.canEdit,
    this.editText = 'แก้ไข',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  (canEdit == true)
                      ? Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  headerText,
                                  style: FontCollection.topicBoldTextStyle,
                                ),
                              ),
                              Container(
                                child: EditButton(
                                  onClicked: onClicked,
                                  editText: editText,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            headerText,
                            style: FontCollection.topicTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                  Container(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildPlainCard extends StatelessWidget {
  BuildPlainCard({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
