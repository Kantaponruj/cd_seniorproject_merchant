import 'package:cs_senior_project/component/roundAppBar.dart';
import 'package:cs_senior_project/notifiers/meeting_notifier.dart';
import 'package:cs_senior_project/notifiers/menu_notifier.dart';
import 'package:cs_senior_project/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage(this.meetingId);
  final String meetingId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    MenuNotifier menuNotifier =
        Provider.of<MenuNotifier>(context, listen: false);
    getMenu(menuNotifier, widget.meetingId);
  }

  @override
  Widget build(BuildContext context) {
    MeetingNotifier meetingNotifier = Provider.of<MeetingNotifier>(context);
    MenuNotifier menuNotifier = Provider.of<MenuNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RoundedAppBar(
        appBarTittle: 'Order Detail',
      ),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Column(children: [
                      Text(menuNotifier.menuList[index].name +
                          "ราคา: " +
                          menuNotifier.menuList[index].price.toString() +
                          " บาท"),
                    ]));
                  },
                  itemCount: menuNotifier.menuList.length),
            ),
            Flexible(
                flex: 8,
                child: Column(children: [
                  Text(meetingNotifier.currentMeeting.customerName),
                  Text("เวลานัดหมาย " +
                      meetingNotifier.currentMeeting.date +
                      " " +
                      meetingNotifier.currentMeeting.time),
                  Text("Address"),
                  Text(meetingNotifier.currentMeeting.address)
                ]))
            // SearchWidget(),
          ],
        ),
      ),
    );
  }
}
