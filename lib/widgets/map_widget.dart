import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key key, @required this.order, @required this.isPreview})
      : super(key: key);
  final order;
  final bool isPreview;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // GoogleMapController mapController;
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints;
  // Set<Polyline> _polylines = Set<Polyline>();

  // @override
  // void initState() {
  //   polylinePoints = PolylinePoints();
  //   super.initState();
  // }

  // void setPolylines(LatLng customerPoint, LatLng storePoint) async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     GOOGLE_MAPS_API_KEY,
  //     PointLatLng(
  //       storePoint.latitude,
  //       storePoint.longitude,
  //     ),
  //     PointLatLng(
  //       customerPoint.latitude,
  //       customerPoint.longitude,
  //     ),
  //     travelMode: TravelMode.walking,
  //   );

  //   if (result.status == 'OK') {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });

  //     setState(() {
  //       _polylines.add(Polyline(
  //         width: 5,
  //         polylineId: PolylineId('polyLine'),
  //         color: Color(0xFF0E7AC7),
  //         points: polylineCoordinates,
  //       ));
  //       // calculateDistance();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    StoreNotifier store = Provider.of<StoreNotifier>(context);
    final routeColor = CollectionsColors.navy;
    final routeWidth = 5;
    final storeName = "จุดเริ่มต้น";
    final customerName = "ลูกค้า";
    final driverName = "ฉัน";
    final storeIcon = "assets/images/restaurant-marker-icon.png";
    final customerIcon = "assets/images/house-marker-icon.png";
    final driverIcon = "assets/images/driver-marker-icon.png";

    return widget.isPreview
        ? GoogleMapsWidget(
            apiKey: GOOGLE_MAPS_API_KEY,
            sourceLatLng: LatLng(
              store.store.realtimeLocation.latitude,
              store.store.realtimeLocation.longitude,
            ),
            destinationLatLng: LatLng(
              double.parse(widget.order['geoPoint'].latitude.toString()),
              double.parse(widget.order['geoPoint'].longitude.toString()),
            ),
            routeWidth: routeWidth,
            routeColor: routeColor,
            sourceMarkerIconInfo: MarkerIconInfo(assetPath: storeIcon),
            destinationMarkerIconInfo: MarkerIconInfo(
              assetPath: customerIcon,
            ),
            sourceName: storeName,
            destinationName: customerName,
            totalTimeCallback: (time) => print(time),
            totalDistanceCallback: (distance) => print(distance),
            // showPolyline: false,
            // polylines: _polylines,
            // onMapCreated: (GoogleMapController controller) {
            //   mapController = controller;
            //   setPolylines(
            //     LatLng(
            //       double.parse(widget.order['geoPoint'].latitude.toString()),
            //       double.parse(widget.order['geoPoint'].longitude.toString()),
            //     ),
            //     LatLng(
            //       store.store.realtimeLocation.latitude,
            //       store.store.realtimeLocation.longitude,
            //     ),
            //   );
            // },
          )
        : GoogleMapsWidget(
            apiKey: GOOGLE_MAPS_API_KEY,
            sourceLatLng: LatLng(
              store.store.realtimeLocation.latitude,
              store.store.realtimeLocation.longitude,
            ),
            destinationLatLng: LatLng(
              double.parse(widget.order['geoPoint'].latitude.toString()),
              double.parse(widget.order['geoPoint'].longitude.toString()),
            ),
            routeWidth: routeWidth,
            routeColor: routeColor,
            sourceMarkerIconInfo: MarkerIconInfo(
              assetPath: storeIcon,
              assetMarkerSize: Size.square(125),
            ),
            destinationMarkerIconInfo: MarkerIconInfo(
              assetPath: customerIcon,
            ),
            driverMarkerIconInfo: MarkerIconInfo(
              assetPath: driverIcon,
            ),
            driverCoordinatesStream: Stream.periodic(
              Duration(milliseconds: 500),
              (i) {
                store.reloadUserModel();
                return LatLng(
                  store.store.realtimeLocation.latitude,
                  store.store.realtimeLocation.longitude,
                );
              },
            ),
            sourceName: storeName,
            destinationName: customerName,
            driverName: driverName,
            totalTimeCallback: (time) => print(time),
            totalDistanceCallback: (distance) => print(distance),
          );
  }
}
