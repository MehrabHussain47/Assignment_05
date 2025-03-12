import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycurrentlocation/screen/control_builder.dart';
import 'package:mycurrentlocation/screen/home_screen.dart';

class LocationApp extends StatelessWidget {
  const LocationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControlBindings(),
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white
          )
      ),
      home: HomeScreen(),
    );
  }
}