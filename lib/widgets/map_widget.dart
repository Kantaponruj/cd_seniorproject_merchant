import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key key, this.order}) : super(key: key);
  final order;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    StoreNotifier store = Provider.of<StoreNotifier>(context);

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: GoogleMapsWidget(
            apiKey: GOOGLE_MAPS_API_KEY,
            sourceLatLng: LatLng(
              store.store.realtimeLocation.latitude,
              store.store.realtimeLocation.longitude,
            ),
            destinationLatLng: LatLng(
              double.parse(widget.order['geoPoint'].latitude.toString()),
              double.parse(widget.order['geoPoint'].longitude.toString()),
            ),
            routeWidth: 2,
            sourceMarkerIconInfo: MarkerIconInfo(
              assetPath: "assets/images/house-marker-icon.png",
            ),
            destinationMarkerIconInfo: MarkerIconInfo(
              assetPath: "assets/images/restaurant-marker-icon.png",
            ),
            sourceName: "ฉัน",
            destinationName: "ลูกค้า",
            totalTimeCallback: (time) => print(time),
            totalDistanceCallback: (distance) => print(distance),
          ),
        ),
      ),
    );
  }
}
