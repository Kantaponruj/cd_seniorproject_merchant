import 'package:cs_senior_project/asset/color.dart';
import 'package:cs_senior_project/asset/text_style.dart';
import 'package:cs_senior_project/component/roundAppBar.dart';
import 'package:cs_senior_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class OpeningHoursPage extends StatefulWidget {
  const OpeningHoursPage({Key key}) : super(key: key);

  @override
  _OpeningHoursPageState createState() => _OpeningHoursPageState();
}

class _OpeningHoursPageState extends State<OpeningHoursPage> {
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
                                    text: 'บันทึก', onClicked: () {}),
                              ],
                            ),
                          ),
                        );
                      });
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

  List<String> _options = [
    'วันจันทร์',
    'วันอังคาร',
    'วันพุธ',
    'วันพฤหัสบดี',
    'วันศุกร์',
    'วันเสาร์',
    'วันอาทิตย์'
  ];
  List<bool> _selected = [false, false, false, false, false, false, false];

  Widget daySelect() {
    List<Widget> chips = new List();

    for (int i = 0; i < _options.length; i++) {
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(
          _options[i],
          style: FontCollection.smallBodyTextStyle,
        ),
        pressElevation: 5,
        backgroundColor: CollectionsColors.grey,
        selectedColor: CollectionsColors.yellow,
        onSelected: (bool selected) {
          setState(() {
            _selected[i] = selected;
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
