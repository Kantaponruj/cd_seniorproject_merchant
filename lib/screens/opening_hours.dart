import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
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
  DateTime _selectedDateTime;
  List _dates = [];

  // Mock up data
  String _openTime = '10.00';
  String _closeTime = '18.00';

  @override
  void initState() {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);

    _selectedDateTime = DateTime();

    getDateAndTime(dateTimeNotifier, widget.storeId);
    super.initState();
  }

  _onSaveDateTime(DateTime dateTime) {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);
    dateTimeNotifier.addDateTime(
        dateTime, dateTimeNotifier.dateTimeList.length);
    Navigator.pop(context);
  }

  _handleSaveDateTime(String storeId) {
    _selectedDateTime.openTime = _openTime;
    _selectedDateTime.closeTime = _closeTime;
    _selectedDateTime.dates = _dates;

    addDateAndTime(_selectedDateTime, storeId, _onSaveDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            content: Container(
                              width: MediaQuery.of(context).size.width,
                              // height: 200,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'เลือกวัน',
                                      style: FontCollection.smallBodyTextStyle,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Wrap(
                                      spacing: 10.0,
                                      runSpacing: 5.0,
                                      children: [
                                        daySelect(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'เลือกเวลา',
                                      style: FontCollection.smallBodyTextStyle,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: timeSelect('เวลาเปิด', '08.00'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 15, 0, 20),
                                    child: timeSelect('เวลาปิด', '18.00'),
                                  ),
                                  SmallStadiumButtonWidget(
                                    text: 'บันทึก',
                                    onClicked: () {
                                      _handleSaveDateTime(widget.storeId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )),
    );
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
  List<bool> _isSelected = [false, false, false, false, false, false, false];

  Widget buildCard(String topicText) {
    DateTimeNotifier dateTimeNotifier = Provider.of<DateTimeNotifier>(context);

    List daysArr = [];
    int textCase;

    showDateTime(int index, DateTime dateTime) {
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
              shrinkWrap: true,
              itemCount: dateTimeNotifier.dateTimeList.length,
              itemBuilder: (context, index) {
                return Container(
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

  Widget timeSelect(
    String topicText,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                topicText,
                style: FontCollection.smallBodyTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.centerLeft,
              // padding: EdgeInsets.only(left: 20),
              child: Text(
                time,
                style: FontCollection.smallBodyTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'เปลี่ยน',
                style: FontCollection.smallBodyTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget daySelect() {
    List<Widget> chips = [];

    for (int i = 0; i < _days.length; i++) {
      FilterChip filterChip = FilterChip(
        selected: _isSelected[i],
        label: Text(
          _days[i],
          style: FontCollection.smallBodyTextStyle,
        ),
        pressElevation: 5,
        backgroundColor: CollectionsColors.grey,
        selectedColor: CollectionsColors.yellow,
        onSelected: (bool selected) {
          setState(() {
            _isSelected[i] = selected;
            _dates.add(i);
          });
        },
      );
      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: filterChip));
    }

    return Wrap(
      spacing: 10.0,
      runSpacing: 5.0,
      children: chips,
    );
  }
}
