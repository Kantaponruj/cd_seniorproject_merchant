import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key key, @required this.isUpdating}) : super(key: key);

  final bool isUpdating;

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
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
                      hidePlaceDetailsWhenDraggingPin: true,
                      usePinPointingSearch: true,
                      resizeToAvoidBottomInset: true,
                      apiKey: GOOGLE_MAPS_API_KEY,
                      initialPosition: location.initialPosition,
                      automaticallyImplyAppBarLeading: false,
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      usePlaceDetailSearch: true,
                      onPlacePicked: (selectedPlace) {
                        location.currentAddress =
                            selectedPlace.formattedAddress;
                        location.newPosition = LatLng(
                          selectedPlace.geometry.location.lat,
                          selectedPlace.geometry.location.lng,
                        );

                        if (widget.isUpdating) {
                          location.newAddress = selectedPlace.formattedAddress;
                        }

                        Navigator.pop(context);
                      },
                      autocompleteLanguage: 'TH',
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
