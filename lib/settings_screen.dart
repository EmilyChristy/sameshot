import 'package:flutter/material.dart';
import 'package:sameshot/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  var textValue = 'Light theme is active';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Dark theme is active';
      });
      //print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Light theme is active';
      });
      //print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sameshot',
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1, // 10%
            child: Container(color: Colors.green[30]),
          ),
          Expanded(
            flex: 8, // 80%
            child: Container(
              color: Colors.green[40],
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text("Settings"),
                  SizedBox(height: 50),
                  Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    activeColor: Colors.indigo[900],
                    activeTrackColor: Colors.lightBlue[100],
                    inactiveThumbColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.lightBlue.shade100,
                  ),
                  Text(textValue),
                  SizedBox(height: 200),
                  RaisedButton(child: const Text("OK Go"), onPressed: () => {})
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1, // 10%
            child: Container(color: Colors.green[30]),
          )
        ],
      ),
    );
  }
}
