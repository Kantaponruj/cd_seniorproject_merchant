import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/mainAppBar.dart';
import 'package:cs_senior_project/notifiers/meeting_notifier.dart';
import 'package:cs_senior_project/screens/orderDetail.dart';
import 'package:cs_senior_project/services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    MeetingNotifier meetingNotifier =
        Provider.of<MeetingNotifier>(context, listen: false);
    getMeeting(meetingNotifier);
  }

  @override
  Widget build(BuildContext context) {
    MeetingNotifier meetingNotifier = Provider.of<MeetingNotifier>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        appBar: MainAppbar(
          appBarTitle: 'คำสั่งซื้อ',
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return buildStoreCard(meetingNotifier, index);
          },
          itemCount: meetingNotifier.meetingList.length,
        ),
      ),
    );
  }

  Widget buildStoreCard(MeetingNotifier meetingNotifier, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: GestureDetector(
        onTap: () {
          meetingNotifier.currentMeeting = meetingNotifier.meetingList[index];
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  OrderDetailPage(meetingNotifier.currentMeeting.meetingId)));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: CollectionsColors.grey,
                            radius: 35.0,
                            child: Text(
                              meetingNotifier.meetingList[index].customerName[0]
                                  .toUpperCase(),
                              style: FontCollection.descriptionTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          meetingNotifier.meetingList[index].customerName,
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'รายละเอียด',
                            style: FontCollection.descriptionTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  // padding: ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                meetingNotifier.meetingList[index].date,
                                textAlign: TextAlign.left,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                meetingNotifier.meetingList[index].time,
                                textAlign: TextAlign.left,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            meetingNotifier.meetingList[index].totalPrice
                                .toString(),
                            style: TextStyle(
                              fontFamily: NotoSansFont,
                              fontWeight: FontWeight.w700,
                              fontSize: bigSize,
                              color: CollectionsColors.red,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            ' บาท',
                            style: FontCollection.bodyTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget priceText(String text) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: NotoSansFont,
          fontWeight: FontWeight.w700,
          fontSize: bigSize,
          color: CollectionsColors.red,
        ),
      ),
    );
  }
}
