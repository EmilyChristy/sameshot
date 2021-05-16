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
  double _opacity = 0;
  final double _opacityDefault = 0.5;
  final opacityValueHolder = TextEditingController();

  void onPressedSavePrefs() {
    _savePrefs();
  }

  //Loading counter value on start
  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    //set opacity to the saved value, or use the default if no user
    //preference has been saved
    setState(() {
      _opacity = (prefs.getDouble('opacity') ?? _opacityDefault);
    });

    //assign value to the ipacity field controller
    opacityValueHolder.text = _opacity.toString();
  }

  //Incrementing counter after click
  void _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _opacity = double.parse(opacityValueHolder.text);

      //save value in user prefs
      prefs.setDouble('opacity', _opacity);
    });
  }

  @override
  void initState() {
    //_controller = new TextEditingController(text: _opacity.toString());

    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    opacityValueHolder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Text(
            '${widget.title}',
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
                    controller: opacityValueHolder,
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
                      onPressed: onPressedSavePrefs,
                      color: Colors.blueAccent,
                      child: Text("Save")),
                )
              ],
            )));
  }
}
