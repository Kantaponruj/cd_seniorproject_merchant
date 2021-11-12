import 'dart:async';
import 'dart:math';

import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
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
  List distanceList = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  Set<Polyline> _polylines = Set<Polyline>();

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
    print(orderNotifier.orderList.map((e) => e.customerName));

    polylinePoints = PolylinePoints();

    print(orderNotifier.orderList.map((e) => e.customerName));

    // meList = [
    //   LatLng(location.currentPosition.latitude,
    //       location.currentPosition.longitude),
    //   LatLng(13.7091526, 100.4742055),
    //   LatLng(13.65927, 100.50082),
    // ];
    super.initState();
  }

  void setPolylines(OrderDetail orderDetail) async {
    LocationNotifier location =
        Provider.of<LocationNotifier>(context, listen: false);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(
        orderDetail.testPoint.latitude,
        orderDetail.testPoint.longitude,
      ),
      PointLatLng(
        orderDetail.geoPoint.latitude,
        orderDetail.geoPoint.longitude,
      ),
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
          width: 5,
          polylineId: PolylineId('polyLine'),
          // color: Color(0xFF0E7AC7),
          points: polylineCoordinates,
        ));
        calculateDistance();
        print(
            'start: ${orderDetail.testPoint.latitude}, ${orderDetail.testPoint.longitude}');
        print('desination: ${orderDetail.customerName}');
      });
    }
  }

  void calculateDistance() {
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
      distanceList.add(_placeDistance);
      polylineCoordinates.clear();
      print('DISTANCE: $_placeDistance km');
      print(distanceList.map((distance) => distance));
    });
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

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            myLocationEnabled: true,
            polylines: _polylines,
            initialCameraPosition: CameraPosition(
              target: locationNotifier.initialPosition,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              widget.mapController.complete(controller);
              for (int i = 0; i < orderNotifier.orderList.length; i++) {
                setPolylines(orderNotifier.orderList[i]);
              }
            },
            markers: Set.from(_markers),
          ),
        ),
      ],
    );
  }
}
