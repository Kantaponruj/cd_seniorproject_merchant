import 'dart:async';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const _marker = 350.0;

class MapWidget extends StatefulWidget {
  const MapWidget({Key key, @required this.mapController}) : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              // target: LatLng(13.655258306757673, 100.49825516513702),
                target: LatLng(13.654794229118206, 100.49792822787104),
                zoom: 15),
            onMapCreated: (GoogleMapController controller) {
              widget.mapController.complete(controller);
            },
          ),
        ),
      ],
    );
  }
}
