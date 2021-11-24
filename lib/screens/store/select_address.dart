import 'dart:async';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key key}) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  // final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);
    locationNotifier.initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocationNotifier location = Provider.of<LocationNotifier>(context);

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: RoundedAppBar(
        appBarTittle: 'ค้นหาสถานที่',
      ),
      body: Stack(
        children: [
          location.initialPosition == null
              ? LoadingWidget()
              : Container(
                  child: Flexible(
                    flex: 15,
                    child: PlacePicker(
                      apiKey: GOOGLE_MAPS_API_KEY,
                      initialPosition: location.initialPosition,
                      automaticallyImplyAppBarLeading: false,
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      usePlaceDetailSearch: true,
                      onPlacePicked: (selectedPlace) {
                        location.currentAddress =
                            selectedPlace.formattedAddress;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   alignment: Alignment.bottomCenter,
      //   height: 180,
      //   margin: EdgeInsets.symmetric(horizontal: 20),
      //   color: Colors.transparent,
      //   child: Column(
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
      //         child: Container(
      //           child: Text(locationNotifier.currentAddress != null
      //               ? locationNotifier.currentAddress
      //               : 'ที่อยู่'),
      //         ),
      //       ),
      //       StadiumButtonWidget(
      //         text: 'เลือกตำแหน่ง',
      //         onClicked: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
