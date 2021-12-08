import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier with ChangeNotifier {
  Geolocator geolocator = Geolocator();
  Position _currentPosition;
  String _currentAddress;
  LatLng _newPosition = LatLng(0, 0);
  String _newAddress = '';

  Map<MarkerId, Marker> _marker;
  final MarkerId markerIdUser = MarkerId("userLocation");
  Set<Marker> _markers = {};

  static LatLng _initialPosition;

  // getter
  LatLng get initialPosition => _initialPosition;
  Position get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  LatLng get newPosition => _newPosition;
  String get newAddress => _newAddress;
  Map<MarkerId, Marker> get marker => _marker;
  Set<Marker> get markers => _markers;

  LocationNotifier() {
    _marker = <MarkerId, Marker>{};
  }

  initialization() async {
    await _determinePosition();
  }

  set currentAddress(String address) {
    _currentAddress = address;
    notifyListeners();
  }

  set newPosition(LatLng position) {
    _newPosition = position;
    notifyListeners();
  }

  set newAddress(String address) {
    _newAddress = address;
    notifyListeners();
  }

  resetNewPosition() {
    _newPosition = LatLng(0, 0);
    _newAddress = '';
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await _getUserLocation();
  }

  _getUserLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      // forceAndroidLocationManager: true
    );
    _initialPosition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = placemarks[0];
    _currentAddress =
        "${place.street}, ${place.locality} ${place.country}, ${place.postalCode}";

    Marker markerUser = Marker(
      markerId: MarkerId('userLocation'),
      position: LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      ),
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
    );
    _marker[markerIdUser] = markerUser;

    notifyListeners();
  }
}
