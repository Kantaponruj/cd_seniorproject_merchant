import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:flutter/material.dart';
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
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            // width: double.infinity,
            // height: double.infinity,
            child: GoogleMap(
              myLocationEnabled: true,
              // polylines: _polylines,
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
      // bottomNavigationBar: Container(
      //   alignment: Alignment.bottomCenter,
      //   height: 180,
      //   margin: EdgeInsets.symmetric(horizontal: 20),
      //   child: nextStartPoint.isNotEmpty
      //       ? Column(
      //           children: [
      //             Row(
      //               children: [
      //                 Text('current point'),
      //                 Text(' -> '),
      //                 Text(nextStartPoint.first['name']),
      //                 SizedBox(width: 10),
      //                 Text(nextStartPoint.first['distance'].toString())
      //               ],
      //             ),
      //             ListView.builder(
      //               shrinkWrap: true,
      //               itemCount: nextStartPoint.length,
      //               itemBuilder: (context, index) {
      //                 return index == nextStartPoint.length - 1
      //                     ? Container()
      //                     : Row(
      //                         children: [
      //                           Text(nextStartPoint[index]['name']),
      //                           Text(' -> '),
      //                           Text(nextStartPoint[index + 1]['name']),
      //                           SizedBox(width: 10),
      //                           Text(nextStartPoint[index + 1]['distance']
      //                               .toString())
      //                         ],
      //                       );
      //               },
      //             ),
      //           ],
      //         )
      //       : Container(),
      // ),
    );
  }
}
