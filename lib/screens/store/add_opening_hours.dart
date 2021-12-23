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
    @required this.isEdit,
  }) : super(key: key);

  final String storeId;
  final bool isEdit;

  @override
  _AddOpeningHoursState createState() => _AddOpeningHoursState();
}

class _AddOpeningHoursState extends State<AddOpeningHours> {
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

  DateTimeModel _selectedDateTime;
  List _dates = [];
  String _openTime;
  String _closeTime;

  TimeOfDay openTime;
  TimeOfDay closedTime;

  @override
  void initState() {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);
    if (widget.isEdit) {
      _selectedDateTime = dateTimeNotifier.currentDateTime;
    } else {
      _selectedDateTime = DateTimeModel();
    }

    _dates = _selectedDateTime.dates;
    _openTime = _selectedDateTime.openTime;
    _closeTime = _selectedDateTime.closeTime;

    _selectedDateTime.dates.forEach((date) {
      for (int i = 0; i < _isSelected.length; i++) {
        if (date == i) {
          _isSelected[i] = true;
        }
      }
    });

    openTime = widget.isEdit
        ? TimeOfDay(
            hour: int.parse(_selectedDateTime.openTime.characters
                .getRange(0, 2)
                .toString()),
            minute: int.parse(_selectedDateTime.openTime.characters
                .getRange(3, 5)
                .toString()))
        : null;
    closedTime = widget.isEdit
        ? TimeOfDay(
            hour: int.parse(_selectedDateTime.closeTime.characters
                .getRange(0, 2)
                .toString()),
            minute: int.parse(_selectedDateTime.closeTime.characters
                .getRange(3, 5)
                .toString()))
        : null;
    super.initState();
  }

  _onSaveDateTime(DateTimeModel dateTime) {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);
    if (!widget.isEdit) {
      dateTimeNotifier.addDateTime(
          dateTime, dateTimeNotifier.dateTimeList.length);
    }
    Navigator.pop(context);
    getDateAndTime(dateTimeNotifier, widget.storeId);
  }

  _onDeleteDateTime(DateTimeModel dateTime) {
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);
    dateTimeNotifier.deleteDateAndTime(dateTime);
    Navigator.pop(context);
    getDateAndTime(dateTimeNotifier, widget.storeId);
  }

  _handleSaveDateTime(String storeId) {
    _selectedDateTime.openTime = _openTime;
    _selectedDateTime.closeTime = _closeTime;
    _selectedDateTime.dates = _dates;

    if (widget.isEdit) {
      addDateAndTime(_selectedDateTime, storeId, true, _onSaveDateTime);
    } else {
      addDateAndTime(_selectedDateTime, storeId, false, _onSaveDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isEdit
                  ? GestureDetector(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        alignment: Alignment.topRight,
                        child: Text(
                          'ลบรายการนี้',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      onTap: () {
                        deleteDateAndTime(
                            _selectedDateTime, widget.storeId, _onDeleteDateTime);
                      },
                    )
                  : SizedBox.shrink(),
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
                child: timeSelect(
                  'เวลาเปิด',
                  getText('openTime'),
                  () async {
                    await pickTime(context, 'openTime');
                    setState(() {
                      _openTime = getText('openTime');
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 20),
                child: timeSelect(
                  'เวลาปิด',
                  getText('closeTime'),
                  () async {
                    await pickTime(context, 'closedTime');
                    setState(() {
                      _closeTime = getText('closeTime');
                    });
                  },
                ),
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
      ),
    );
  }

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
            print(_isSelected);
            if (selected) {
              _dates.add(i);
            } else {
              _dates.removeWhere((date) => date == i);
              print(_dates);
            }
            _dates.sort();
            setState(() {});
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

  String getText(String whatTime) {
    TimeOfDay time;

    if (whatTime == 'openTime') {
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

    if (whatTime == 'openTime') {
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
      if (whatTime == 'openTime') {
        openTime = time;
      } else {
        closedTime = time;
      }
    });
  }
}
