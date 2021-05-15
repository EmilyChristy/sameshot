import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.color, this.title, this.materialIndex: 500});
  final MaterialColor color;
  final String title;
  final int materialIndex;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _opacity = 0;
  TextEditingController _controller;

  void onPressed() {
    _savePrefs();
  }

  @override
  void initState() {
    _controller = new TextEditingController(text: '3');

    super.initState();
    _loadPrefs();
  }

  //Loading counter value on start
  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _opacity = (prefs.getInt('opacity') ?? 0);
    });
    print("Opacity is $_opacity");
  }

  //Incrementing counter after click
  void _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _opacity = 5;
      prefs.setInt('opacity', _opacity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Text(
            '${widget.title}[${widget.materialIndex}]',
          ),
        ),
        body: Container(
            color: widget.color[widget.materialIndex],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter opacity value',
                        labelText: "Opacity"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter left or right',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                      onPressed: onPressed,
                      color: Colors.blueAccent,
                      child: Text("Save")),
                )
              ],
            )));
  }
}
