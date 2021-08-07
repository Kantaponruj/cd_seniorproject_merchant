import 'package:cs_senior_project_merchant/models/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cs_senior_project_merchant/notifiers/storeNotifier.dart';

class StoreListWidget extends StatelessWidget {
  const StoreListWidget({Key key, @required this.mapController})
      : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    final maxSizeOpen = 0.6;
    final maxSizeClosed = 0.1;
    final initialSizeOpen = 0.3;

    return DraggableScrollableSheet(
      initialChildSize: initialSizeOpen,
      minChildSize: maxSizeClosed,
      maxChildSize: maxSizeOpen,
      builder: (context, controller) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          color: Colors.blue,
          child: ListView.builder(
            controller: controller,
            itemCount: storeNotifier.storeList.length,
            itemBuilder: (context, index) {
              final store = storeNotifier.storeList[index];
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  buildStore(store),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildStore(Store store) => ListTile(
    leading: Image.network(
      store.image != null
          ? store.image
          : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
      width: 100,
      fit: BoxFit.cover,
    ),

    title: Text(
      store.name,
      style: TextStyle(fontSize: 24),
    ),
    subtitle: Text(
      store.address,
    ),
  );

}