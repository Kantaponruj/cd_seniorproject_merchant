import 'dart:async';

import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _marker = 350.0;

class OriginalMapWidget extends StatefulWidget {
  OriginalMapWidget({
    Key key,
  }) : super(key: key);

  @override
  _OriginalMapWidgetState createState() => _OriginalMapWidgetState();
}

class _OriginalMapWidgetState extends State<OriginalMapWidget> {
  GoogleMapController mapController;

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  Set<Polyline> _polylines = Set<Polyline>();

  LatLng currentLocation;

  @override
  void initState() {
    polylinePoints = PolylinePoints();
    setInitialLocation();
    super.initState();
  }

  void setInitialLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation = await LatLng(position.latitude, position.longitude);
  }

  void setPolylines(LatLng customerPoint) async {
    LocationNotifier location =
        Provider.of<LocationNotifier>(context, listen: false);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(
        location.currentPosition.latitude,
        location.currentPosition.longitude,
      ),
      PointLatLng(
        customerPoint.latitude,
        customerPoint.longitude,
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
          color: Color(0xFF0E7AC7),
          points: polylineCoordinates,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    LocationNotifier locationNotifier = Provider.of<LocationNotifier>(context);

    _openOnGoogleMapApp(double latitude, double longitude) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        // Could not open the map.
      }
    }

    Iterable _markers = Iterable.generate(
      orderNotifier.orderList.length,
      (index) {
        return Marker(
          markerId: MarkerId(orderNotifier.orderList[index]['orderId']),
          icon: BitmapDescriptor.defaultMarkerWithHue(_marker),
          position: LatLng(
            orderNotifier.orderList[index]['geoPoint'].latitude,
            orderNotifier.orderList[index]['geoPoint'].longitude,
          ),
          infoWindow: InfoWindow(
            title: orderNotifier.orderList[index]['customerName'],
            snippet: orderNotifier.orderList[index]['address'],
            onTap: () {
              _openOnGoogleMapApp(
                orderNotifier.orderList[index]['geoPoint'].latitude,
                orderNotifier.orderList[index]['geoPoint'].longitude,
              );
            },
          ),
          onTap: () {
            polylineCoordinates.clear();
            setPolylines(
              LatLng(
                orderNotifier.orderList[index]['geoPoint'].latitude,
                orderNotifier.orderList[index]['geoPoint'].longitude,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              padding: EdgeInsets.only(bottom: 20, top: 100),
              myLocationEnabled: true,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: locationNotifier.initialPosition,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: Set.from(_markers),
            ),
          ),
        ],
      ),
    );
  }
}
