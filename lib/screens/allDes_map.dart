import 'dart:async';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/widgets/original_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AllDestinationPage extends StatefulWidget {
  AllDestinationPage({Key key}) : super(key: key);

  @override
  _AllDestinationPageState createState() => _AllDestinationPageState();
}

class _AllDestinationPageState extends State<AllDestinationPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  final panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: RoundedAppBar(
        appBarTittle: 'All destination',
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: OriginalMapWidget(
              mapController: _mapController,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     Container(
                  //       child: Text(
                  //         'First points ' + nextStartPoint.first['name'],
                  //         style: FontCollection.bodyTextStyle,
                  //       ),
                  //     ),
                  //     Container(
                  //       padding: EdgeInsets.only(left: 20),
                  //       child: Text(
                  //         'Distance: ' +
                  //             nextStartPoint.first['distance'].toString(),
                  //         style: FontCollection.bodyTextStyle,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: nextStartPoint.length,
                    itemBuilder: (context, index) {
                      return index == nextStartPoint.length - 1
                          ? Container()
                          : showOrder(
                        nextStartPoint[index]['name'],
                        nextStartPoint[index + 1]['name'],
                        nextStartPoint[index + 1]['distance']
                            .toString(),
                      );
                    },
                  ),
                  // nextStartPoint.isNotEmpty
                  //     ? ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemCount: nextStartPoint.length,
                  //         itemBuilder: (context, index) {
                  //           return index == nextStartPoint.length - 1
                  //               ? Container()
                  //               : showOrder(
                  //                   nextStartPoint[index]['name'],
                  //                   nextStartPoint[index + 1]['name'],
                  //                   nextStartPoint[index + 1]['distance']
                  //                       .toString(),
                  //                 );
                  //         },
                  //       )
                  //     : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
      // Stack(
      //   // fit: StackFit.expand,
      //   children: [
      //     SlidingUpPanel(
      //       color: Theme.of(context).backgroundColor,
      //       controller: panelController,
      //       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      //       maxHeight: 420,
      //       panelBuilder: (scrollController) => ClipRRect(
      //         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      //         child: buildSlidingPanel(),
      //       ),
      //       body: Padding(
      //         padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
      //         child: OriginalMapWidget(
      //           mapController: _mapController,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget buildDragHandle() => GestureDetector(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                'ลำดับการจัดส่ง',
                style: FontCollection.topicTextStyle,
              ),
            ),
          ],
        ),
      );

  Widget buildSlidingPanel() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: buildDragHandle(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Text('current point'),
              //     Text(' -> '),
              //     Text(nextStartPoint.first['name']),
              //     SizedBox(width: 10),
              //     Text(nextStartPoint.first['distance'].toString())
              //   ],
              // ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: nextStartPoint.length,
                itemBuilder: (context, index) {
                  return index == nextStartPoint.length - 1
                      ? Container()
                      : showOrder(
                          nextStartPoint[index]['name'],
                          nextStartPoint[index + 1]['name'],
                          nextStartPoint[index + 1]['distance'].toString(),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showOrder(String startPoint, String stopPoint, String distance) {
    return Row(
      children: [
        Container(
          child: Text(
            startPoint + ' to ',
            style: FontCollection.bodyTextStyle,
          ),
        ),
        Container(
          child: Text(
            stopPoint,
            style: FontCollection.bodyTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Distance: ' + distance,
            style: FontCollection.bodyTextStyle,
          ),
        ),
      ],
    );
  }
}
