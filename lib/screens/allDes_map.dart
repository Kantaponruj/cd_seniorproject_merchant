import 'dart:math';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/order/orderDetail.dart';
import 'package:cs_senior_project_merchant/widgets/icontext_widget.dart';
import 'package:cs_senior_project_merchant/widgets/original_map_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AllDestinationPage extends StatefulWidget {
  AllDestinationPage({Key key}) : super(key: key);

  @override
  _AllDestinationPageState createState() => _AllDestinationPageState();
}

class _AllDestinationPageState extends State<AllDestinationPage> {
  final panelController = PanelController();

  List allPoints = [];
  List nextStartPoint = [];
  List distanceList = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  // Set<Polyline> _polylines = Set<Polyline>();

  String _placeDistance;

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);

    polylinePoints = PolylinePoints();

    for (int i = 0; i < orderNotifier.orderList.length; i++) {
      LatLng endPoint = LatLng(
        orderNotifier.orderList[i].geoPoint.latitude,
        orderNotifier.orderList[i].geoPoint.longitude,
      );
      setPolylines(
        locationNotifier.initialPosition,
        endPoint,
        orderNotifier.orderList[i].customerName,
        orderNotifier.orderList.length,
      );
    }
    super.initState();
  }

  void setPolylines(
      LatLng startPoint, LatLng endPoint, String customer, int length) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(startPoint.latitude, startPoint.longitude),
      PointLatLng(endPoint.latitude, endPoint.longitude),
      // travelMode: TravelMode.bicycling,
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        // _polylines.add(Polyline(
        //   width: 5,
        //   polylineId: PolylineId('polyLine'),
        //   // color: Color(0xFF0E7AC7),
        //   points: polylineCoordinates,
        // ));
        print('start: ${startPoint.latitude}, ${startPoint.longitude}');
        print('desination: ${customer}');
        calculateDistance(
          customer,
          LatLng(endPoint.latitude, endPoint.longitude),
          length,
        );
      });
    }
  }

  void calculateDistance(String name, LatLng point, int length) {
    double totalDistance = 0.0;

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      distanceList.add(double.parse(_placeDistance));
      polylineCoordinates.clear();
      print('DISTANCE: $_placeDistance km');
      allPoints.add({
        'name': name,
        'point': point,
        'distance': double.parse(_placeDistance)
      });
      if (distanceList.length == length) {
        sortDistance(name, point);
      }
    });
  }

  void sortDistance(String name, LatLng point) {
    distanceList.sort();
    print('sort: ${distanceList}');

    allPoints.forEach((data) {
      if (data['distance'] == distanceList.first) {
        nextStartPoint.add(data);
        print(nextStartPoint);
      }
    });

    allPoints.removeWhere((data) => data['distance'] == distanceList.first);
    print(allPoints);

    print('new round');
    for (int i = 0; i < allPoints.length; i++) {
      setPolylines(
        nextStartPoint[nextStartPoint.length - 1]['point'],
        allPoints[i]['point'],
        allPoints[i]['name'],
        allPoints.length,
      );
    }
    allPoints.clear();
    distanceList.clear();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double mapHeight = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: RoundedAppBar(
          appBarTittle: 'All destination',
        ),
        body: Stack(
          children: [
            Container(
              height: mapHeight,
              child: OriginalMapWidget(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, mapHeight - 20, 0, 0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: MediaQuery.of(context).size.height / 2 + 20,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: CollectionsColors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'ลำดับการส่ง',
                        style: FontCollection.topicTextStyle,
                      ),
                    ),
                    Flexible(
                      child: nextStartPoint.isNotEmpty
                          ? Column(
                              children: [
                                showOrders(
                                    'My location',
                                    nextStartPoint.first['name'],
                                    nextStartPoint.first['distance'].toString(),
                                    1),
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: nextStartPoint.length,
                                  itemBuilder: (context, index) {
                                    return index == nextStartPoint.length - 1
                                        ? Container()
                                        : showOrders(
                                            nextStartPoint[index]['name'],
                                            nextStartPoint[index + 1]['name'],
                                            nextStartPoint[index + 1]
                                                    ['distance']
                                                .toString(),
                                            index + 2,
                                          );
                                  },
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }


  Widget showOrders(
      String startPoint, String stopPoint, String distance, int index) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20),
      //   color: CollectionsColors.yellow,
      // ),
      padding: EdgeInsets.all(10),
      // margin: EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailPage(
                      storeId: storeNotifier.user.uid, order: orderNotifier)));
        },
        leading: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CollectionsColors.orange,
            // border: Border.all(
            //   width: 1,
            //   color: Colors.black,
            // ),
          ),
          child: Text(
            index.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                stopPoint,
                style: FontCollection.bodyTextStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: BuildIconText(
                icon: Icons.location_on,
                text: distance,
                color: CollectionsColors.yellow,
              ),
              // Text(
              //   'Distance: ' + distance,
              //   style: FontCollection.bodyTextStyle,
              // ),
            ),
          ],
        ),
        trailing: Icon(Icons.navigate_next),
      ),
    );
  }
}
