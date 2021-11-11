import 'dart:async';

import 'package:cs_senior_project_merchant/asset/constant.dart';
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
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getOrderDelivery(orderNotifier, storeNotifier.store.storeId);
    polylinePoints = PolylinePoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

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
          infoWindow:
              InfoWindow(title: orderNotifier.orderList[index].customerName),
        );
      },
    );

    void setPolylines() async {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(mapPointsLat[0], mapPointsLong[0]),
        PointLatLng(mapPointsLat[mapPointsLat.length - 1],
            mapPointsLong[mapPointsLong.length - 1]),
      );

      if (result.status == 'OK') {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        setState(() {
          _polylines.add(Polyline(
            width: 10,
            polylineId: PolylineId('polyLine'),
            // color: Color(0xFF08A5CB),
            points: polylineCoordinates,
          ));
        });
      }
    }

    Set<Marker> markers = Set<Marker>();
    void showMarker() {
      setState(() {
        mapLatLngPoints.forEach((point) {
          markers.add(Marker(
            markerId: MarkerId('Customer Marker'),
            position: point,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "ลูกค้า"),
          ));
        });
        // _markers.add(Marker(
        //   markerId: MarkerId('Customer Marker'),
        //   position: customerLocation,
        //   icon: BitmapDescriptor.defaultMarker,
        //   infoWindow: InfoWindow(title: "ลูกค้า"),
        // ));
        //
        // _markers.add(Marker(
        //   markerId: MarkerId('Store Marker'),
        //   position: storeLocation,
        //   icon: BitmapDescriptor.defaultMarkerWithHue(90),
        //   infoWindow: InfoWindow(title: "ฉัน"),
        // ));
      });
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                storeNotifier.store.realtimeLocation.latitude,
                storeNotifier.store.realtimeLocation.longitude,
              ),
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              widget.mapController.complete(controller);
              setPolylines();
              showMarker();
            },
            markers: markers,
            polylines: _polylines,
          ),
        ),
      ],
    );
  }
}

// List<double> mapPointsLat = [
//   13.669958031011886,
//   13.661828287801896,
//   13.656017333496989,
//   13.652092206175759,
// ];
//
// List<double> mapPointsLong = [
//   100.50512423594903,
//   13.661828287801896,
//   100.49947792461327,
//   100.49736730851575,
// ];

List<double> mapPointsLat = [
  13.670318509718392,
  13.647418258518739,
  13.653562202505691,
];

List<double> mapPointsLong = [
  100.50548105821792,
  100.49591999228957,
  100.49741439513559,
];

List<LatLng> mapLatLngPoints = [
  LatLng(13.669958031011886, 100.50512423594903),
  LatLng(13.661828287801896, 13.661828287801896),
  LatLng(13.656017333496989, 100.49947792461327),
  LatLng(13.652092206175759, 100.49736730851575),
];
