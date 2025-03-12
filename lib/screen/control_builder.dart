import 'package:get/get.dart';
import 'package:mycurrentlocation/controller/maps_marker_polyline_controller.dart';

class ControlBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(MapsMarkerPolylineController());
  }
}