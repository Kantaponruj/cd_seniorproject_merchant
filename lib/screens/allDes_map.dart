import 'dart:math';

import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/widgets/original_map_widget.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: RoundedAppBar(
          appBarTittle: 'All destination',
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: OriginalMapWidget(),
                ),
                SingleChildScrollView(
                  child: Expanded(
                    child: nextStartPoint.isNotEmpty
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      '1. First points is ' +
                                          nextStartPoint.first['name'],
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Distance: ' +
                                          nextStartPoint.first['distance']
                                              .toString(),
                                      style: FontCollection.bodyTextStyle,
                                    ),
                                  ),
                                ],
                              ),
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
                                          index + 2,
                                        );
                                },
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget showOrder(
      String startPoint, String stopPoint, String distance, int index) {
    return Row(
      children: [
        Container(
          child: Text(
            index.toString() + '. ' + startPoint + ' to ',
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
