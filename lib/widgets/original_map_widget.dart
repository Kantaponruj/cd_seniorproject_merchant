import 'dart:async';
import 'dart:math';

import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const _marker = 350.0;

class OriginalMapWidget extends StatefulWidget {
  OriginalMapWidget({Key key, @required this.mapController}) : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  _OriginalMapWidgetState createState() => _OriginalMapWidgetState();
}

class _OriginalMapWidgetState extends State<OriginalMapWidget> {
  List nextStartPoint = [];
  List allPoints = [];
  List distanceList = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  // Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> meList = [];

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
    // print(
    //     'me: ${locationNotifier.initialPosition.latitude}, ${locationNotifier.initialPosition.longitude}');
    super.initState();
  }

  void setPolylines(
      LatLng startPoint, LatLng endPoint, String customer, int length) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(startPoint.latitude, startPoint.longitude),
      PointLatLng(endPoint.latitude, endPoint.longitude),
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
      // print(allPoints);
      // print(distanceList.map((distance) => distance));
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
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    Iterable _markers = Iterable.generate(
      orderNotifier.orderList.length,
      (index) {
        return Marker(
          markerId: MarkerId(orderNotifier.orderList[index].orderId),
          icon: BitmapDescriptor.defaultMarkerWithHue(_marker),
          position: LatLng(
            orderNotifier.orderList[index].geoPoint.latitude,
            orderNotifier.orderList[index].geoPoint.longitude,
          ),
          infoWindow: InfoWindow(
            title: orderNotifier.orderList[index].customerName,
            snippet: orderNotifier.orderList[index].address,
          ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            // width: double.infinity,
            // height: double.infinity,
            child: Flexible(
              flex: 15,
              child: GoogleMap(
                myLocationEnabled: true,
                // polylines: _polylines,
                initialCameraPosition: CameraPosition(
                  target: locationNotifier.initialPosition,
                  zoom: 15,
                ),
                onMapCreated: (GoogleMapController controller) {
                  widget.mapController.complete(controller);
                },
                markers: Set.from(_markers),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        height: 180,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: nextStartPoint.isNotEmpty
            ? Column(
                children: [
                  Row(
                    children: [
                      Text('current point'),
                      Text(' -> '),
                      Text(nextStartPoint.first['name']),
                      SizedBox(width: 10),
                      Text(nextStartPoint.first['distance'].toString())
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: nextStartPoint.length,
                    itemBuilder: (context, index) {
                      return index == nextStartPoint.length - 1
                          ? Container()
                          : Row(
                              children: [
                                Text(nextStartPoint[index]['name']),
                                Text(' -> '),
                                Text(nextStartPoint[index + 1]['name']),
                                SizedBox(width: 10),
                                Text(nextStartPoint[index + 1]['distance']
                                    .toString())
                              ],
                            );
                    },
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
