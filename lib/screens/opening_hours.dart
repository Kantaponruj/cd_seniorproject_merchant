import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpeningHoursPage extends StatefulWidget {
  const OpeningHoursPage({Key key}) : super(key: key);

  @override
  _OpeningHoursPageState createState() => _OpeningHoursPageState();
}

class _OpeningHoursPageState extends State<OpeningHoursPage> {
  DateTime _selectedDateTime;
  List<String> _dates = [];

  // Mock up data
  String _openTime = '10.00';
  String _closeTime = '18.00';

  _onSaveDateTime(DateTime dateTime) {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);
    dateTimeNotifier.addDateTime(dateTime);
    Navigator.pop(context);
  }

  _handleSaveDateTime() {
    StoreNotifier storeNotifier = Provider.of(context, listen: false);

    _selectedDateTime.openTime = _openTime;
    _selectedDateTime.closeTime = _closeTime;
    _selectedDateTime.dates = _dates;

    addDateAndTime(
        _selectedDateTime, storeNotifier.store.storeId, _onSaveDateTime);
  }

  @override
  void initState() {
    _selectedDateTime = DateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTittle: 'เวลาทำการ',
        ),
        body: Container(
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
                                  _handleSaveDateTime();
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
      ),
    );
  }

  Widget buildCard(String topicText) {
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

            ///TODO do listView
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'จันทร์ - อังคาร',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                  Container(
                    child: Text(
                      '08.00 - 18.00',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget daySelect() {
    List<Widget> chips = new List();

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
            _dates.add(_days[i]);
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
