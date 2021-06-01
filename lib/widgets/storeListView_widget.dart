import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cs_senior_project/notifiers/storeNotifier.dart';

class StoreListWidget extends StatelessWidget {
  const StoreListWidget({Key key, @required this.mapController})
      : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(
              storeNotifier.storeList[index].image != null
                  ? storeNotifier.storeList[index].image
                  : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
              width: 100,
              fit: BoxFit.cover,
            ),
            title: Text(storeNotifier.storeList[index].name),
            subtitle: Text(storeNotifier.storeList[index].address),
            onTap: () async {
              final controller = await mapController.future;
              await controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                          storeNotifier.storeList[index].location.latitude,
                          storeNotifier.storeList[index].location.longitude),
                      zoom: 18)));
            },
          );
        },
        itemCount: storeNotifier.storeList.length,
      ),
    );
  }
}
