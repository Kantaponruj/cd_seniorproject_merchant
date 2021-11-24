import 'dart:ffi';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOpeningHours extends StatefulWidget {
  AddOpeningHours({
    Key key,
    @required this.storeId,
  }) : super(key: key);

  final String storeId;

  @override
  _AddOpeningHoursState createState() => _AddOpeningHoursState();
}

class _AddOpeningHoursState extends State<AddOpeningHours> {
  DateTimeModel _selectedDateTime;

  List _dates = [];

  String _openTime = '10.00';
  String _closeTime = '18.00';

  @override
  void initState() {
    DateTimeNotifier dateTimeNotifier =
    Provider.of<DateTimeNotifier>(context, listen: false);

    _selectedDateTime = DateTimeModel();

    getDateAndTime(dateTimeNotifier, widget.storeId);
    super.initState();
  }

  _onSaveDateTime(DateTimeModel dateTime) {
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
              child: timeSelect('เวลาเปิด', getText('openTime'), () async {
                await pickTime(context, 'openTime');
                setState(() {

                });
              }),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 20),
              child: timeSelect('เวลาปิด', getText('closeTime'), () {
                pickTime(context, 'closedTime');
                print(closedTime);
              }),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: EditButton(
                      editText: 'ยกเลิก',
                      onClicked: () {
                        Navigator.of(context).pop();
                      },
                    ),
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
          ],
        ),
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

  Widget timeSelect(
      String topicText,
      String time,
      VoidCallback onPressed,
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
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'เปลี่ยน',
                  style: FontCollection.underlineButtonTextStyle,
                ),
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
            setState(() {
            });
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

  TimeOfDay openTime;
  TimeOfDay closedTime;

  String getText(String whatTime) {
    TimeOfDay time;

    if(whatTime == 'openTime') {
      time = openTime;
    } else {
      time = closedTime;
    }

    if (time == null) {
      return 'เลือกเวลา';
    } else {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  Future pickTime(BuildContext context, String whatTime) async {
    TimeOfDay time;

    if(whatTime == 'openTime') {
      time = openTime;
    } else {
      time = closedTime;
    }

    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() {
      time = newTime;
      if(whatTime == 'openTime') {
        openTime = time;
      } else {
        closedTime = time;
      }
    });
  }

}
