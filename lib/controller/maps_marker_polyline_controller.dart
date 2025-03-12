import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsMarkerPolylineController extends GetxController{
  List<LatLng> polylineList = [];
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;


  set mapController(GoogleMapController? mapController) {
    _mapController = mapController;
  }
  Set<Polyline> get polyline =>_polylines;
  Set<Marker> get markers =>_markers;

  void updateUserLocation(double lat, double lng) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('real-time-location'),
        position: LatLng(lat, lng),
        infoWindow:  InfoWindow(title: 'My Location',snippet: '$lat, $lng'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    polylineList.add(LatLng(lat, lng));
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('tracking'),
        points: polylineList,
        color: Colors.blue,
        width: 7,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    update();
  }
}