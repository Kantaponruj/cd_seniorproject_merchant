import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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

  // String _placeDistance;

  // double _coordinateDistance(lat1, lon1, lat2, lon2) {
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((lat2 - lat1) * p) / 2 +
  //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  //   return 12742 * asin(sqrt(a));
  // }

  @override
  void initState() {
    polylinePoints = PolylinePoints();
    super.initState();
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
      // travelMode: TravelMode.walking,
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
        // calculateDistance();
      });
    }
  }

  // void calculateDistance() {
  //   double totalDistance = 0.0;

  //   for (int i = 0; i < polylineCoordinates.length - 1; i++) {
  //     totalDistance += _coordinateDistance(
  //       polylineCoordinates[i].latitude,
  //       polylineCoordinates[i].longitude,
  //       polylineCoordinates[i + 1].latitude,
  //       polylineCoordinates[i + 1].longitude,
  //     );
  //   }

  //   setState(() {
  //     _placeDistance = totalDistance.toStringAsFixed(2);
  //     print('DISTANCE: $_placeDistance km');
  //   });
  // }

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
          onTap: () {
            polylineCoordinates.clear();
            setPolylines(
              LatLng(
                orderNotifier.orderList[index].geoPoint.latitude,
                orderNotifier.orderList[index].geoPoint.longitude,
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
              myLocationEnabled: true,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: locationNotifier.initialPosition,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                // setPolylines();
              },
              markers: Set.from(_markers),
            ),
          ),
        ],
      ),
    );
  }
}
