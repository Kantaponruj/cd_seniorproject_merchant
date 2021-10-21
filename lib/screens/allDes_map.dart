import 'dart:async';

import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/widgets/map_widget_not_used.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllDestinationPage extends StatefulWidget {
  AllDestinationPage({Key key}) : super(key: key);

  @override
  _AllDestinationPageState createState() => _AllDestinationPageState();
}

class _AllDestinationPageState extends State<AllDestinationPage> {

  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'All destination',
      ),
      body: OriginalMapWidget(
        mapController: _mapController,
      ),
    );
  }
}
