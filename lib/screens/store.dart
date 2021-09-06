import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/storeCard.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/store/address.dart';
import 'package:cs_senior_project_merchant/screens/store/opening_hours.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:cs_senior_project_merchant/models/dateTime.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool _deliveryStatus;
  bool _storeStatus;

  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    DateTimeNotifier dateTimeNotifier =
        Provider.of<DateTimeNotifier>(context, listen: false);
    getDateAndTime(dateTimeNotifier, storeNotifier.store.storeId);

    _deliveryStatus = storeNotifier.store.deliveryStatus;
    _storeStatus = storeNotifier.store.storeStatus;

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    DateTimeNotifier dateTimeNotifier = Provider.of<DateTimeNotifier>(context);

    final double imgHeight = MediaQuery.of(context).size.height / 4;
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

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: imgHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: storeNotifier.store.image.isNotEmpty
                            ? Image.network(
                                storeNotifier.store.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Image.asset(
                                'assets/images/shop_test.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, imgHeight - 30, 20, 30),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF2954E),
                                    Color(0xFFFAD161)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 9,
                                              child: Text(storeNotifier
                                                  .store.storeName, style: FontCollection.topicBoldTextStyle,),),
                                          Expanded(
                                            flex: 3,
                                            child: EditButton(editText: 'แก้ไขข้อมูล',onClicked: () {},),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child:
                                          Text(storeNotifier.store.kindOfFood),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Icon(Icons.call),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 0, 0),
                                            child: Text(
                                              storeNotifier.store.phone,
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  switchCard(
                                    'สถานะการส่ง',
                                    (val) {
                                      setState(
                                        () {
                                          _deliveryStatus = val;
                                          storeNotifier.updateUserData(
                                              {"deliveryStatus": val});
                                        },
                                      );
                                    },
                                    _deliveryStatus,
                                  ),
                                  switchCard(
                                    'สถานะร้านค้า',
                                    (val) {
                                      setState(
                                        () {
                                          _storeStatus = val;
                                          storeNotifier.updateUserData(
                                              {"storeStatus": val});
                                        },
                                      );
                                    },
                                    _storeStatus,
                                  )
                                ],
                              ),
                            ),
                            storeCard(
                              onClicked: () {},
                              headerText: 'รายละเอียดร้านค้า',
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    storeNotifier.store.description,
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ),
                            ),
                            storeCard(
                              onClicked: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpeningHoursPage(
                                            storeId:
                                                storeNotifier.store.storeId)));
                              },
                              headerText: 'เวลาทำการ',
                              child: dateTimeNotifier.dateTimeList.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: dateTimeNotifier
                                                .dateTimeList.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    showDateTime(
                                                        index,
                                                        dateTimeNotifier
                                                                .dateTimeList[
                                                            index]),
                                                    Container(
                                                      child: Text(
                                                        dateTimeNotifier
                                                                .dateTimeList[
                                                                    index]
                                                                .openTime +
                                                            " - " +
                                                            dateTimeNotifier
                                                                .dateTimeList[
                                                                    index]
                                                                .closeTime,
                                                        style: FontCollection
                                                            .bodyTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          'ไม่มีช่วงวันและเวลาขาย',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ),
                            ),
                            storeCard(
                              onClicked: () {},
                              headerText: 'รูปแบบการจัดส่ง',
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    //TODO delivery type
                                    'ประเภทการจัดส่ง',
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ),
                              canEdit: false,
                            ),
                            storeCard(
                              onClicked: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressPage(
                                            storeId:
                                                storeNotifier.store.storeId)));
                              },
                              headerText: 'สถานที่ขาย',
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          storeNotifier
                                              .store.selectedAddressName,
                                          style:
                                              FontCollection.bodyBoldTextStyle,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          storeNotifier.store.selectedAddress,
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //end
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget switchCard(String headerText, Function handleToggle, bool status) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  headerText,
                  style: FontCollection.bodyTextStyle,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: 100,
                child: FlutterSwitch(
                  width: 100,
                  showOnOff: true,
                  activeTextColor: CollectionsColors.white,
                  activeColor: CollectionsColors.orange,
                  inactiveTextColor: CollectionsColors.white,
                  activeText: 'เปิด',
                  inactiveText: 'ปิด',
                  activeTextFontWeight: FontWeight.w400,
                  inactiveTextFontWeight: FontWeight.w400,
                  value: status,
                  onToggle: handleToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
