import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({this.color, this.title, this.materialIndex: 500});
  final MaterialColor color;
  final String title;
  final int materialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          '$title[$materialIndex]',
        ),
      ),
      body: Container(
        color: color[materialIndex],
      ),
    );
  }
}
