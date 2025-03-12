import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycurrentlocation/screen/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Image.asset('assets/banner.png'),
                  Text(
                    'Welcome to',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'My Current Location App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: ElevatedButton(
                  onPressed: _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    fixedSize: Size(double.maxFinite, 50),
                  ),
                  child: Text(
                    'Get Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (await _checkPermissionStatus()) {
      if (await _isGpsServiceEnable()) {
        // ONE TIME LOCATION
        showDialog(context: context, builder: (context) {
          return
            Dialog(
              backgroundColor: Colors.transparent,
              child:  Center(child: Text('Loading....',style: TextStyle(color: Colors.white),)),);
        },);
        _currentPosition = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
            )
        );
        Get.back();
        Get.to(MapScreen(currentPosition: _currentPosition));

      } else {
        _requestGpsService();
      }
    } else {
      _requestPermission();
    }
  }


  Future<bool> _checkPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }
    return false;
  }

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      _getCurrentLocation();
      return true;
    }
    return false;
  }

  Future<bool> _isGpsServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _requestGpsService() async {
    await Geolocator.openLocationSettings();
  }


}