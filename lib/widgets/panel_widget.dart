// import 'dart:async';
// // import 'dart:js';
//
// import 'package:cs_senior_project/notifiers/storeNotifier.dart';
// import 'package:cs_senior_project/services/store_service.dart';
// import 'package:cs_senior_project/widgets/storeListView.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
// class PanelWidget extends StatelessWidget {
//   final ScrollController controller;
//   final PanelController panelController;
//   // final Completer<GoogleMapController> mapController;
//
//   PanelWidget({
//     Key key,
//     @required this.controller,
//     @required this.panelController,
//     // @required this.mapController,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//         padding: EdgeInsets.zero,
//         controller: controller,
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 12,
//             ),
//             buildDragHandle(),
//             SizedBox(
//               height: 18,
//             ),
//             Center(
//               child: Text(
//                 "สำรวจร้านค้า",
//                 style: TextStyle(fontWeight: FontWeight.normal),
//               ),
//             ),
//             SizedBox(
//               height: 36,
//             ),
//             // Flexible(flex: 3,child: StoreListWidget(mapController: mapController,),),
//             SizedBox(
//               height: 24,
//             ),
//             buildAboutText(),
//             SizedBox(
//               height: 24,
//             ),
//           ],
//         ),
//       );
//
//
//   Widget buildDragHandle() => GestureDetector(
//         child: Center(
//           child: Container(
//             width: 30,
//             height: 5,
//             decoration: BoxDecoration(
//               color: Colors.black54,
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//         ),
//         onTap: togglePanel,
//       );
//
//   void togglePanel() => panelController.isPanelOpen
//       ? panelController.close()
//       : panelController.open();
//
//   Widget buildAboutText() => Container(
//         padding: EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
//           ],
//         ),
//       );
//
//   Widget buildListview() => ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           ListTile(
//             title: Text('All'),
//             onTap: () {},
//           ),
//           ListTile(
//             title: Text('Delivery'),
//             onTap: () {},
//           ),
//           ListTile(
//             title: Text('Pickup'),
//             onTap: () {},
//           ),
//           const Divider(),
//         ],
//       );
// }
//
