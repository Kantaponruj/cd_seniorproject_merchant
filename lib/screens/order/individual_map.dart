import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class CustomerMap extends StatefulWidget {
  CustomerMap({Key key, @required this.order}) : super(key: key);

  final order;

  @override
  _CustomerMapState createState() => _CustomerMapState();
}

class _CustomerMapState extends State<CustomerMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        appBarTittle: 'Map',
      ),
      body: MapWidget(
        order: widget.order,
        isPreview: true,
      ),
    );
  }
}
