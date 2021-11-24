import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:cs_senior_project_merchant/screens/store/add_opening_hours.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpeningHoursPage extends StatefulWidget {
  const OpeningHoursPage({Key key, @required this.storeId}) : super(key: key);
  final String storeId;

  @override
  _OpeningHoursPageState createState() => _OpeningHoursPageState();
}

class _OpeningHoursPageState extends State<OpeningHoursPage> {

  @override
  void initState() {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);


    getDateAndTime(dateTimeNotifier, widget.storeId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RoundedAppBar(
          appBarTittle: 'เวลาทำการ',
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Container(
                  child: buildCard('เวลาเปิดทำการ'),
                ),
                StadiumButtonWidget(
                  text: 'เพิ่มเวลาทำการ',
                  onClicked: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AddOpeningHours(
                          storeId: widget.storeId,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  List<String> _days = [
    'วันจันทร์',
    'วันอังคาร',
    'วันพุธ',
    'วันพฤหัสบดี',
    'วันศุกร์',
    'วันเสาร์',
    'วันอาทิตย์'
  ];

  Widget buildCard(String topicText) {
    DateTimeNotifier dateTimeNotifier = Provider.of<DateTimeNotifier>(context);

    List daysArr = [];
    int textCase;

    showDateTime(int index, DateTimeModel dateTime) {
      if (dateTime.dates.length >= 2) {
        daysArr = [];
        for (int i = 0; i < dateTime.dates.length - 1; i++) {
          if ((dateTime.dates[i].isOdd && dateTime.dates[i + 1].isEven) ||
              (dateTime.dates[i].isEven && dateTime.dates[i + 1].isOdd)) {
            daysArr.add(_days[dateTime.dates[i]]);
            textCase = 1;
          } else {
            daysArr.add(_days[dateTime.dates[i]]);
            textCase = 2;
          }
        }

        daysArr.add(_days[dateTime.dates[dateTime.dates.length - 1]]);

        return Container(
          child: textCase == 1
              ? Text(
                  daysArr[0] + " - " + daysArr[daysArr.length - 1],
                  style: FontCollection.bodyTextStyle,
                )
              : Row(
                  children: [
                    Text(daysArr.join(', '),
                        style: FontCollection.bodyTextStyle)
                  ],
                ),
        );
      } else {
        daysArr = [];
        daysArr.add(_days[dateTime.dates[0]]);

        return Container(
          child: Text(
            daysArr[0],
            style: FontCollection.bodyTextStyle,
          ),
        );
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                topicText,
                style: FontCollection.orderDetailHeaderTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dateTimeNotifier.dateTimeList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showDateTime(index, dateTimeNotifier.dateTimeList[index]),
                      Container(
                        child: Text(
                          dateTimeNotifier.dateTimeList[index].openTime +
                              " - " +
                              dateTimeNotifier.dateTimeList[index].closeTime,
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

}
