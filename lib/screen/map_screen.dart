import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mycurrentlocation/controller/maps_marker_polyline_controller.dart';

class MapScreen extends StatefulWidget {
  final Position? currentPosition;
  const MapScreen({super.key, required this.currentPosition});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapsMarkerPolylineController mapsMarkerPolylineController = Get.find<MapsMarkerPolylineController>();
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    _listenCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    latitude = widget.currentPosition!.latitude;
    longitude = widget.currentPosition!.longitude;

    return Scaffold(
      appBar: AppBar(title: Text('Real Time Location Tracking')),
      body: GetBuilder<MapsMarkerPolylineController>(
          builder: (controller) {
            return GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                zoom: 17,
                target: LatLng(latitude, longitude),
              ),
              onMapCreated: (GoogleMapController mapcontroller) {
                controller.mapController = mapcontroller;
              },
              markers: controller.markers,
              polylines: controller.polyline,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              trafficEnabled: true,
            );
          }
      ),
    );
  }

  Future<void> _listenCurrentLocation() async {
    if (await _checkPermissionStatus()) {
      if (await _isGpsServiceEnable()) {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
              timeLimit: Duration(seconds: 10)
          ),
        ).listen((pos) {
          mapsMarkerPolylineController.updateUserLocation(pos.latitude, pos.longitude);
        });
      } else {
        _requestGpsService();
      }
    } else {
      _requestPermission();
    }
  }


  Future<bool> _checkPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> _isGpsServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _requestGpsService() async {
    await Geolocator.openLocationSettings();
  }
}