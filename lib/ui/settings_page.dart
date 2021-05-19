import 'package:flutter/material.dart';
import 'package:sameshot/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sameshot/theme/config.dart';

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
  bool isSwitched = false;
  bool isLeftHanded = false;

  var textValue = "Theme: " + currentTheme.toString();

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

    //assign value to the opacity field controller
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
        // appBar: AppBar(
        //   //backgroundColor: widget.color,
        //   title: Text(
        //     '${widget.title}',
        //   ),
        // ),
        body: Container(
            color: CustomColors.lightBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Image.asset(
                        'images/sameshotlogo.png',
                        height: 40.0,
                        fit: BoxFit.cover,
                      )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Overlay transparency"),
                ),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Choose where you want the controls"),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Left handed"),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            isLeftHanded = value;
                            //currentTheme.toggleTheme();
                          });
                        },
                        value: isLeftHanded,
                        activeColor: Colors.indigo[900],
                        activeTrackColor: Colors.lightBlue[100],
                        inactiveThumbColor: Colors.blueAccent,
                        inactiveTrackColor: Colors.lightBlue.shade100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Right handed"),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Which theme"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Switch(
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        currentTheme.toggleTheme();
                      });
                    },
                    value: isSwitched,
                    activeColor: Colors.indigo[900],
                    activeTrackColor: Colors.lightBlue[100],
                    inactiveThumbColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.lightBlue.shade100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(textValue),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                          onPressed: onPressedSavePrefs,
                          color: Colors.blueAccent,
                          child: Text("Save")),
                    ),
                  ],
                )
              ],
            )));
  }
}
