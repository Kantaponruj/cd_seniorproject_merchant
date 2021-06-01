import 'dart:async';

import 'package:cs_senior_project/widgets/search_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../asset/color.dart';
import 'package:cs_senior_project/component/appBar.dart';
import 'package:cs_senior_project/component/located_FAB.dart';
import 'package:cs_senior_project/widgets/mapsWidget.dart';
import 'package:cs_senior_project/notifiers/storeNotifier.dart';
import 'package:cs_senior_project/models/store.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  static final String title = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _mapController = Completer();

  String query = ' ';

  // static const double heightClosed = 200;
  // static const double fabHeightClosed = heightClosed + 20;
  // double fabHeight = fabHeightClosed;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    final maxSizeOpen = 0.6;
    final maxSizeClosed = 0.1;
    final initialSizeOpen = 0.3
    // MediaQuery.of(context).size.height * 0.1
        ;

    return Scaffold(
      appBar: RoundedAppBar(key: UniqueKey(), title: Text('Home'),),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(mapController: _mapController),
          DraggableScrollableSheet(
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
          ),
          Positioned(
            right: 20,
            bottom: 600,
            child: locateFAB(context),
          ),
        ],
      ),
    );
  }

  // Widget buildSearch() => SearchWidget(
  //   text:query,
  //   hintText: 'Title or Author Name',
  //   // onChanged: searchBook,
  // );

  Widget buildDragHandle() => GestureDetector(
    child: Center(
      child: Container(
        width: 30,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );

  Widget buildStore(Store store) => ListTile(
    // leading: Image.network(
    //   store != null
    //       ? store.image
    //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
    //   width: 100,
    //   fit: BoxFit.cover,
    // ),
    title: Text(
      store.name,
      style: TextStyle(fontSize: 24),
    ),
    subtitle: Text(
      store.address,
    ),
  );


}
