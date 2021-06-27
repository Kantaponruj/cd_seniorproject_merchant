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

    return Scaffold(
      appBar: MainAppbar(
        appBarTitle: 'คำสั่งซื้อ',
      ),
      body: Container(
          child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return buildStoreCard(meetingNotifier, index);
        },
        itemCount: meetingNotifier.meetingList.length,
      )),
    );
  }

  Widget buildStoreCard(MeetingNotifier meetingNotifier, int index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 35.0,
                        child: Text('Name'),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        meetingNotifier.meetingList[index].customerName,
                        style: TextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          meetingNotifier.currentMeeting =
                              meetingNotifier.meetingList[index];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OrderDetailPage(meetingNotifier
                                      .currentMeeting.meetingId)));
                        },
                        child: Text(
                          'Detailed',
                          style: TextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text('เวลาจัดส่ง เวลาปัจจุบัน'),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        'ราคา ' +
                            meetingNotifier.meetingList[index].totalPrice +
                            ' บาท',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
