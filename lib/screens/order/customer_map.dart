import 'dart:async';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/map_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'orderDetail.dart';

class CustomerMapPage extends StatefulWidget {
  CustomerMapPage({Key key}) : super(key: key);

  @override
  _CustomerMapPageState createState() => _CustomerMapPageState();
}

class _CustomerMapPageState extends State<CustomerMapPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  final panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
        children: [
          SlidingUpPanel(
            color: Theme.of(context).backgroundColor,
            controller: panelController,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            maxHeight: 420,
            panelBuilder: (scrollController) => ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: buildSlidingPanel(
                scrollController: scrollController,
                panelController: panelController,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: MapWidget(mapController: _mapController),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  Widget buildSlidingPanel({
    @required PanelController panelController,
    @required ScrollController scrollController,
  }) =>
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          elevation: 0,
          title: Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: buildDragHandle(),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Text(
                    'คำสั่งซื้อ',
                    style: FontCollection.topicTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildIconText(Icons.access_time, '12.30 น.'),
                    TextButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         OrderDetailPage(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'รายละเอียดคำสั่งซื้อ',
                        style: FontCollection.underlineButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              customerInfo(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'ราคารวม',
                        style: FontCollection.topicTextStyle,
                      ),
                    ),
                    Container(
                      child: Text(
                        '95 บาท',
                        style: FontCollection.topicTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: StadiumButtonWidget(
                  text: 'จัดส่งเรียบร้อยแล้ว',
                  onClicked: () {},
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildIconText(IconData icon, String text) {
    return Container(
      child: Row(
        children: [
          Container(
            child: Icon(icon),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: FontCollection.topicTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  final height = 50.0;
  final width = 50.0;

  Widget customerInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          userPicAndName(),
          Container(
            width: width,
            height: height,
            // alignment: Alignment.centerRight,
            child: MaterialButton(
              color: CollectionsColors.yellow,
              textColor: Colors.white,
              child: Icon(
                Icons.call,
              ),
              shape: CircleBorder(),
              onPressed: () async {
                String number = '0862584569';
                // launch('tel://$number');
                await FlutterPhoneDirectCaller.callNumber(number);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget userPicAndName() {
    return Container(
      child: Row(
        children: [
          Container(
            width: width,
            height: height,
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: CollectionsColors.yellow,
              radius: height,
              child: Text(
                'A',
                style: FontCollection.descriptionTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Jane Cooper',
              style: FontCollection.bodyTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
