import 'package:flutter/material.dart';
//import 'camerascreen/camera_screen.dart';
import 'home/home_page.dart';
import 'package:sameshot/theme/custom_theme.dart';

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sameshot',
      home: HomePage(),
      theme: CustomTheme.lightTheme,
    );
  }
}

void main() => runApp(CameraApp());
